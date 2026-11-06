"""Shared discovery and file helpers for compatible inference providers."""

import json
import os
from pathlib import Path
import ssl
import tempfile
import urllib.error
import urllib.parse
import urllib.request


def connection_source():
    """Resolve configuration at runtime, including paths supplied by sops-nix."""
    return Path(os.environ.get("CUSTOM_LLM_CONFIG", str(
        Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "custom-llm/config.json"
    ))).expanduser()


def positive_int(value):
    return value if isinstance(value, int) and not isinstance(value, bool) and value > 0 else None


def atomic_write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, temporary = tempfile.mkstemp(dir=path.parent)
    try:
        with os.fdopen(fd, "w") as stream:
            stream.write(text)
        os.replace(temporary, path)
    finally:
        Path(temporary).unlink(missing_ok=True)


def discover(source):
    """Read runtime config, with optional llama-swap context verification."""
    source = source.resolve()
    connection = json.loads(source.read_text())
    if "api_key_file" in connection:
        key_path = Path(connection["api_key_file"]).expanduser()
        if not key_path.is_absolute():
            key_path = source.parent / key_path
        connection["api_key"] = key_path.read_text().strip()
    base_url = connection["base_url"].rstrip("/")
    origin = base_url.removesuffix("/v1")
    certificate = connection.get("ca_cert_pem")
    if certificate is None and "ca_cert" in connection:
        ca_path = Path(connection["ca_cert"]).expanduser()
        if not ca_path.is_absolute():
            ca_path = source.parent / ca_path
        certificate = ca_path.read_text()
    if certificate is None:
        certificate = "".join(ssl.DER_cert_to_PEM_cert(cert)
                              for cert in ssl.create_default_context().get_ca_certs(binary_form=True))
    tls = ssl.create_default_context(cadata=certificate)

    def fetch(url):
        request = urllib.request.Request(url, headers={
            "Authorization": "Bearer " + connection["api_key"], "Accept": "application/json"})
        with urllib.request.urlopen(request, context=tls, timeout=30) as response:
            return json.load(response)

    configured_models = connection.get("models", {})
    if connection.get("discover_models", True):
        rows = fetch(base_url + "/models")["data"]
    else:
        rows = [{"id": model} for model in configured_models]
    if not rows:
        raise ValueError("Endpoint returned no models; config was not changed")
    try:
        running = ({row["model"] for row in fetch(origin + "/running")["running"]
                    if row.get("state") == "ready"}
                   if connection.get("llama_swap", False) else set())
    except (urllib.error.URLError, KeyError, ValueError) as error:
        print(f"Warning: cannot read /running ({error}); using advertised limits")
        running = set()
    models = {}
    for row in rows:
        model = row["id"]
        configured = configured_models.get(model, {})
        context = (positive_int(configured.get("context_length"))
                   or positive_int(row.get("context_length"))
                   or positive_int(row.get("meta", {}).get("n_ctx"))
                   or positive_int(connection.get("default_context_length")))
        advertised = context
        verified = False
        if model in running:
            upstream = origin + "/upstream/" + urllib.parse.quote(model, safe="")
            try:
                slots = fetch(upstream + "/slots")
                capacities = [positive_int(slot.get("n_ctx")) for slot in slots]
                if capacities and all(capacities):
                    context = min(capacities)
                    verified = True
            except (urllib.error.URLError, KeyError, TypeError, ValueError) as error:
                print(f"Warning: cannot verify slots for {model}: {error}")
        if not context:
            raise ValueError(f"No context limit for {model}; set models.<id>.context_length or default_context_length")
        entry = {**configured, "context_length": context}
        capabilities = row.get("capabilities", {})
        if "vision" in capabilities:
            entry["supports_vision"] = bool(capabilities["vision"])
        elif row.get("architecture", {}).get("input_modalities"):
            entry["supports_vision"] = "image" in row["architecture"]["input_modalities"]
        models[model] = entry
        detail = "verified from running slots" if verified else "advertised; not verified"
        if verified and context != advertised:
            detail += f"; llama-swap advertises {advertised}"
        print(f"{model}: {context:,} tokens ({detail})")
    return connection, base_url, certificate, models
