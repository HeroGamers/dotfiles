# custom-llm

Packages the provider discovery, configuration sync, Claude compatibility adapter,
and local web MCP scripts with Python, PyYAML, MCP, and DDGS. No checkout or uv is
needed at runtime. Install Claude Code and/or Hermes separately on PATH.

Build with `nix build .#custom-llm`. Commands are `claude-custom` and
`hermes-custom`, with `-check` (preview) and `-sync` (write configuration) variants.
Launch commands sync first and preserve the current project directory. CLI
arguments pass through to the client. Sync commands accept `--source PATH` and
`--model MODEL_ID`. Override the Nix package's `commandSuffix` to change `custom`.

Configuration is read from `CUSTOM_LLM_CONFIG`, defaulting to
`$XDG_CONFIG_HOME/custom-llm/config.json` or `~/.config/custom-llm/config.json`:

```json
{
  "base_url": "https://inference.example.com/v1",
  "api_key_file": "/run/secrets/inference-api-key",
  "model": "your-model",
  "default_context_length": 32768
}
```

`base_url` is the OpenAI-compatible API root, including `/v1` when appropriate.
Use `anthropic_base_url` when the Anthropic API has a separate root URL. Otherwise
it defaults to `base_url` with a trailing `/v1` removed. Claude requires Anthropic
Messages compatibility; an
OpenAI-only endpoint cannot serve Claude Code. Client-specific protocol and tool
support still depend on the provider.

Model discovery uses `/models`. For providers without discovery, set
`"discover_models": false` and supply a `models` object mapping model IDs to
objects such as `{"context_length": 32768, "supports_vision": false}`. Explicit
model limits override advertised limits; `default_context_length` is a fallback.
Set `"llama_swap": true` to inspect ready models' running slot limits as well.
This may reload a model if it unloads between discovery and slot inspection.

TLS uses system trust by default. Optionally set `ca_cert` to a PEM file (relative
paths resolve against the config), or embed PEM text in `ca_cert_pem`. Connection settings can be generated with `pkgs.writeText` and `builtins.toJSON`.
Set `api_key_file` to a sops-nix secret readable by the launching user. Only its
path enters the Nix store. Relative key paths resolve against the config. Inline
`api_key` is also supported for existing external configs; never put such a config
in the Nix store. Supply connection settings separately when using this package.

Claude uses `~/.claude-custom` unless `CUSTOM_LLM_CLAUDE_PROFILE` is set.
Hermes uses `HERMES_HOME` or `~/.hermes`, selecting a provider named `custom`.
Sync preserves other settings and backs up existing config. Credentials and CA
are copied into these private client profiles at launch; secret rotation takes
effect on the next sync or launch. Changing models in Claude requires relaunching
so its context limit matches. Set `claude_normalize_system_messages` to `true` for backends requiring system
messages before conversation messages (off by default). Claude's loopback adapter
applies this workaround only when enabled; its web MCP runs using the packaged Python dependencies.

The scripts originated in the SOC inference-client checkout and are maintained
here independently. The original checkout and its plaintext config are untouched.
