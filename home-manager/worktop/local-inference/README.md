# Local inference on worktop

Reference for serving local models with llama.cpp and making them available in
OMP. Worktop's [Home Manager configuration](../home.nix) declares the manual-only
`llama-laptop` service. Model downloads, the model preset, OMP configuration,
and optional worker definitions remain editable outside Nix. Choose models and
quantizations that fit the laptop GPU, including context and runtime buffers.

## Configure llama.cpp

Worktop installs CUDA-enabled llama.cpp. Under WSL, user services need the
Windows GPU library path explicitly:

```bash
LD_LIBRARY_PATH=/usr/lib/wsl/lib llama-server --list-devices
```

Download GGUF models to a directory of your choice. Create
`~/.config/llama.cpp/laptop-models.ini` using this structure, replacing the
model paths and names. INI paths must be absolute; shell variables are not
expanded. The section names become the model IDs used by clients.

```ini
version = 1

[*]
ctx-size = 8192
parallel = 1
n-gpu-layers = 999
sleep-idle-seconds = -1
load-on-startup = false

[coding-model]
model = /absolute/path/to/coding-model.gguf
ctx-size = 32768
load-on-startup = true

[decision-model]
model = /absolute/path/to/decision-model.gguf
load-on-startup = true
```

Add or remove sections as needed. Set model-specific options, such as
`reasoning = off`, in the corresponding section. Adjust context and parallel
slots to suit the model and available VRAM.
OMP's system prompt and tool schemas can exceed 8K tokens before any useful
conversation fits. Start chat models at 32K when memory allows, and use the
same context limit in OMP. Compaction cannot shrink this fixed prompt overhead.

The service is installed when worktop's Home Manager configuration is activated.
For the initial migration, move the earlier manually installed unit out of the
way before activating the new configuration, so Home Manager can own its path:

```bash
mv "$HOME/.config/systemd/user/llama-laptop.service" \
  "$HOME/.config/systemd/user/llama-laptop.service.manual-backup"
```

Skip that migration step on a fresh installation. After activation, start the
service manually with `just start` or `systemctl --user start llama-laptop`.

The service allows two resident models. Change `--models-max` in `home.nix`
and rebuild only when that service setting needs changing. Adding or replacing
models within that limit requires editing the preset and restarting the service,
without rebuilding. The separate router cache keeps unrelated cached models out
of the roster.
Automatic loading on requests is disabled; the selected models load at startup
and idle unloading is disabled. Each model runs in a child process behind the
same endpoint.

The service file has no `[Install]` section and is not enabled or attached to
a startup target. It survives WSL restarts as a definition but runs only when
started manually. Stopping it releases the models and GPU memory:

```bash
systemctl --user start llama-laptop
systemctl --user stop llama-laptop
systemctl --user status llama-laptop
```

From this directory, the [justfile](justfile) provides the same controls:

```bash
just start
just stop
just restart
just status
just logs
just logs 100
just follow
```

Run `just` to list the commands. These recipes operate on the installed user
service and do not enable automatic startup.

After editing the model preset, use `systemctl --user restart llama-laptop`.
Change the service definition through `home.nix` and activate the updated
configuration; do not edit Home Manager's generated unit file directly.

If a failed unit name remains, run
`systemctl --user reset-failed llama-laptop` before starting again.

## Register models in OMP

Back up `~/.omp/agent/models.yml`, then merge a provider into its existing
`providers` mapping. Preserve other providers and credentials. Match IDs and
context limits to the router preset. This example includes a chat model and an
optional native System One decision model:

```yaml
providers:
  laptop:
    baseUrl: http://127.0.0.1:8081/v1
    api: openai-completions
    auth: none
    models:
      - id: coding-model
        name: Laptop coding model
        reasoning: false
        input: [text]
        contextWindow: 32768
        maxTokens: 4096
      - id: decision-model
        name: Laptop decision model
        api: typesafe
        baseUrl: http://127.0.0.1:8081
        kind: judge
        reasoning: false
        input: [text]
        contextWindow: 8192
        maxTokens: 1
```

Set reasoning support to match the chat model and its server configuration.
Use `api: typesafe` only for decision models that support `/v1/systemone`.
The API and base URL can be overridden per model, so chat and decision models
can share a provider despite using different protocols.

Select a chat model with `/switch laptop/coding-model` in a new OMP session.
`/switch` changes the active session model; `/model` opens model and role
configuration. From a shell, use `omp --model laptop/coding-model`. Start a
fresh session when trying a smaller model rather than inheriting a long
conversation from the remote model.
Adding a provider does not assign model roles. Keep local models manually
selectable while experimenting; configure `modelRoles`, fallback chains, or
planning handoffs separately when wanted. Routing helper requests to another
model on a remote swapping server can evict its main model.

A judge registration is not a tool approval gate. OMP 18.13.2 has no built-in
judge-based tool approval mode. Assigning `modelRoles.judge` selects the model
for OMP's judgment features; it does not change `tools.approvalMode`.

## Save thinking support per model

Thinking can be configured on an individual OMP model instead of passing a
launch flag that affects the session. For a Qwen-compatible model with an
on/off thinking toggle, replace `reasoning: false` with:

```yaml
reasoning: true
thinking:
  mode: effort
  efforts: [medium]
  defaultLevel: medium
  requiresEffort: false
compat:
  thinkingFormat: qwen-chat-template
  supportsReasoningEffort: false
  supportsReasoningParams: true
```

Set `reasoning = auto` in that model's llama.cpp preset and restart the service.
OMP sends `chat_template_kwargs.enable_thinking` to select on or off. Here
`medium` represents enabled thinking, not a measured reasoning budget. Use this
configuration only for a model and template that support that toggle.

After restarting OMP, `/switch laptop/coding-model` applies the saved default.
Use `/switch laptop/coding-model:off` for a temporary thinking-off selection or
`:medium` to turn it on. Thinking generates extra tokens before the answer and
can substantially increase latency. Keep `reasoning: false` for a model that
should always run without thinking.

## Add an optional local worker

Create `~/.omp/agent/agents/local.md` to make the laptop model available for
explicit delegation without changing ordinary subagent routing:

```markdown
---
name: local
description: Optional laptop worker. Use only when the user explicitly requests local delegation.
model: laptop/coding-model
thinking: medium
tools: read, grep, glob, bash, edit, write, lsp
spawns: []
blocking: true
---

Complete only the delegated task. Read relevant files before changing them,
follow repository instructions, and report findings, changes, and validation.
If the assignment does not establish an explicit user request for local
delegation, ask the parent to confirm it. Do not launch other agents.
Inspect the environment only when the assignment requires it.
```

Replace the model selector with a registered laptop model and choose a supported
thinking level. Ask the main agent, for example: "Use the local worker to write
tests for this function, then review its changes." This restriction is an
instruction to the agents, not an enforced approval policy. `/agents` shows
available workers; restart OMP if a newly added worker is not listed.

Start inference, launch plain `omp`, and ask it to use the local worker for a
specific task. The parent can remain on a remote model. OMP does not start the
inference service automatically. If the service is stopped, local calls fail
with a connection error; if a model is unloaded while the router is running,
requests fail because `--no-models-autoload` is set. Start the service or load
the model explicitly, then retry.

To prevent local inference failures from switching to a remote fallback, merge
this into `~/.omp/agent/config.yml` while preserving other fallback entries:

```yaml
retry:
  fallbackChains:
    laptop/*: []
```

Transient connection errors may still be retried under the normal retry policy.
With the router running, load or unload one model without stopping the others:

```bash
curl --fail http://127.0.0.1:8081/models/load \
  -H 'Content-Type: application/json' -d '{"model":"coding-model"}'
curl --fail http://127.0.0.1:8081/models/unload \
  -H 'Content-Type: application/json' -d '{"model":"coding-model"}'
```

## Inspect and verify

```bash
curl --fail http://127.0.0.1:8081/models
journalctl --user -u llama-laptop -n 40 --no-pager
/usr/lib/wsl/lib/nvidia-smi
omp models laptop --kind all
omp models laptop --kind judge
```

Wait for the intended models to report `loaded`. Try each through its API or
OMP, then check `/models` again to confirm that switching between models keeps
them resident. If loading fails, inspect the logs and reduce context, slots,
model size, or the number of resident models.

The router and mixed chat/judge provider were tested with llama.cpp build
11669 (`620d222`) and OMP 18.13.2. Consult upstream documentation when upgrading:

- [llama.cpp router and presets](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md#using-multiple-models)
- [OMP model configuration](https://github.com/can1357/oh-my-pi/blob/main/docs/models.md)
- [OMP tool approval modes](https://github.com/can1357/oh-my-pi/blob/main/docs/approval-mode.md)
