"""Loopback compatibility adapter for strict llama.cpp chat templates."""

from contextlib import contextmanager
import hmac
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import secrets
import ssl
import threading
import urllib.error
import urllib.parse
import urllib.request


def normalize_system_messages(body):
    """Move system/developer messages into the Anthropic top-level system field.

    Claude Code 2.1.314 appends system messages after user messages. The active
    Qwen template accepts system instructions only at the start. Keep instruction
    content and order, while leaving user/assistant/tool blocks unchanged.
    """
    body = dict(body)
    system = body.get("system", [])
    system = [{"type": "text", "text": system}] if isinstance(system, str) else list(system)
    messages = []
    for message in body.get("messages", []):
        if message.get("role") in ("system", "developer"):
            content = message.get("content", "")
            system.extend([{"type": "text", "text": content}] if isinstance(content, str) else content)
        else:
            messages.append(message)
    body["messages"] = messages
    if system:
        body["system"] = system
    return body


@contextmanager
def bridge(base_url, api_key, certificate, normalize=False):
    """Run an authenticated, streaming, localhost-only adapter for one client."""
    token = secrets.token_urlsafe(32)
    tls = ssl.create_default_context(cafile=str(certificate))
    upstream = base_url.rstrip("/").removesuffix("/v1")

    class Handler(BaseHTTPRequestHandler):
        def log_message(self, *args):
            pass  # Never log credentials or conversation bodies.

        def forward(self):
            authorization = self.headers.get("Authorization", "")
            if not hmac.compare_digest(authorization, "Bearer " + token):
                self.send_error(401)
                return
            path = urllib.parse.urlsplit(self.path).path
            if path not in ("/v1/messages", "/v1/messages/count_tokens", "/v1/models"):
                self.send_error(404)
                return
            data = None
            if self.command == "POST":
                try:
                    length = int(self.headers.get("Content-Length", "0"))
                    if not 0 < length <= 32 * 1024 * 1024:
                        raise ValueError("Invalid request length")
                    body = json.loads(self.rfile.read(length))
                    if normalize:
                        body = normalize_system_messages(body)
                    data = json.dumps(body).encode()
                except (ValueError, TypeError):
                    self.send_error(400)
                    return
            headers = {"Authorization": "Bearer " + api_key, "Content-Type": "application/json"}
            for name in ("anthropic-version", "anthropic-beta", "Accept"):
                if self.headers.get(name):
                    headers[name] = self.headers[name]
            request = urllib.request.Request(upstream + self.path, data=data,
                                             headers=headers, method=self.command)
            try:
                try:
                    response = urllib.request.urlopen(request, context=tls, timeout=900)
                except urllib.error.HTTPError as error:
                    response = error
                with response:
                    self.send_response(response.status)
                    self.send_header("Content-Type", response.headers.get("Content-Type", "application/json"))
                    self.send_header("Connection", "close")
                    self.end_headers()
                    while chunk := response.read1(65536):
                        self.wfile.write(chunk)
                        self.wfile.flush()
            except (BrokenPipeError, ConnectionResetError):
                pass
            except (OSError, urllib.error.URLError):
                self.close_connection = True

        do_POST = forward
        do_GET = forward

    server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    try:
        yield f"http://127.0.0.1:{server.server_port}", token
    finally:
        server.shutdown()
        server.server_close()
        thread.join()
