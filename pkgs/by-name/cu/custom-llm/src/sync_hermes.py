"""Sync a Hermes provider from a compatible inference provider."""

import argparse
import json
import os
from pathlib import Path
import shutil

import yaml

from llama_swap import atomic_write, connection_source, discover


def synchronize(args):
    connection, base_url, certificate, models = discover(args.source)

    selected = args.model or connection.get("model")
    if selected not in models:
        raise ValueError(f"Selected model {selected!r} is not advertised; use --model")
    home = args.hermes_home.expanduser().resolve()
    config_path = home / "config.yaml"
    config = (yaml.safe_load(config_path.read_text()) if config_path.exists() else {}) or {}
    provider = config.setdefault("providers", {}).setdefault("custom", {})
    previous_models = provider.get("models", {})
    if isinstance(previous_models, dict):
        models = {key: {**previous_models.get(key, {}), **value} for key, value in models.items()}
    provider.update({
        "name": base_url, "api": base_url,
        "key_env": "CUSTOM_LLM_API_KEY", "transport": "chat_completions",
        "default_model": selected, "ssl_ca_cert": str(home / "certs" / "provider.pem"),
        "ssl_verify": True, "discover_models": connection.get("discover_models", True), "models": models})
    for key in ("api_key", "key_cmd", "api_key_env", "base_url", "url", "api_mode"):
        provider.pop(key, None)
    config["model"] = {"provider": "custom", "default": selected,
                       "base_url": base_url, "api_mode": "chat_completions"}
    rendered = yaml.safe_dump(config, sort_keys=False)
    if args.check:
        print(f"\nPreview only: would update {config_path} and select {selected}")
        return
    env_path = home / ".env"
    env_lines = env_path.read_text().splitlines() if env_path.exists() else []
    env_lines = [line for line in env_lines
                 if not line.lstrip().removeprefix("export ").startswith("CUSTOM_LLM_API_KEY=")]
    secret = connection["api_key"].replace("\\", "\\\\").replace("'", "\\'")
    env_lines.append("CUSTOM_LLM_API_KEY='" + secret + "'")
    if config_path.exists():
        shutil.copy2(config_path, config_path.with_suffix(".yaml.bak"))
        config_path.with_suffix(".yaml.bak").chmod(0o600)
    atomic_write(home / "certs" / "provider.pem", certificate)
    atomic_write(env_path, "\n".join(env_lines) + "\n")
    atomic_write(config_path, rendered)
    print(f"\nUpdated {config_path}; selected {selected}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=connection_source())
    parser.add_argument("--hermes-home", type=Path,
                        default=Path(os.environ.get("HERMES_HOME", "~/.hermes")))
    parser.add_argument("--model", help="Model to select; defaults to config.json's model")
    parser.add_argument("--check", action="store_true", help="Query and preview without writing")
    try:
        synchronize(parser.parse_args())
    except (OSError, ValueError, KeyError, TypeError, yaml.YAMLError) as error:
        parser.exit(1, f"Sync failed: {error}\n")


if __name__ == "__main__":
    main()
