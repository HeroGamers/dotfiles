"""Configure and launch a separate Claude Code profile for a compatible inference provider."""

import argparse
import json
import os
from pathlib import Path
import shlex
import shutil
import subprocess
import sys
import tempfile

from claude_bridge import bridge
from llama_swap import atomic_write, connection_source, discover


# Tool availability is separate from permission policy. A deny rule for an
# unsupported built-in makes auto mode reject legitimate MCP replacements too.
LOCAL_BUILTIN_TOOLS = (
    "Agent", "AskUserQuestion", "Bash", "Edit", "EnterPlanMode",
    "EnterWorktree", "ExitPlanMode", "ExitWorktree", "Glob", "Grep", "LSP",
    "NotebookEdit", "Read", "Skill", "TaskCreate", "TaskGet", "TaskList",
    "TaskOutput", "TaskStop", "TaskUpdate", "ToolSearch", "Write",
)


def tool_arguments(arguments):
    # Preserve an explicitly restricted tool list (e.g. --tools '' for a test).
    if any(value == "--tools" or value.startswith("--tools=") for value in arguments):
        return []
    return ["--tools", ",".join(LOCAL_BUILTIN_TOOLS)]


def launch_model(arguments):
    """Find the last CLI model override so context matches the actual launch."""
    model = None
    for index, value in enumerate(arguments):
        if value in ("--model", "-m"):
            if index + 1 >= len(arguments):
                raise ValueError(f"{value} requires a model ID")
            model = arguments[index + 1]
        elif value.startswith("--model="):
            model = value.split("=", 1)[1]
    return model


def synchronize(args):
    profile = args.profile_dir.expanduser().resolve()
    if profile == Path.home() / ".claude":
        raise ValueError("Choose a separate profile directory instead of ~/.claude")
    settings_path = profile / "settings.json"
    web_policy_marker = profile / ".web-tool-policy-v2"
    migrate_web_policy = (profile / "web-mcp.json").exists() and not web_policy_marker.exists()
    settings = json.loads(settings_path.read_text()) if settings_path.exists() else {}
    forwarded = args.claude_args
    if forwarded[:1] == ["--"]:
        forwarded = forwarded[1:]
    connection, base_url, certificate, models = discover(args.source)
    anthropic_url = connection.get("anthropic_base_url", base_url.removesuffix("/v1"))
    selected = launch_model(forwarded) or args.model or settings.get("model") or connection.get("model")
    if selected not in models:
        raise ValueError(f"Selected model {selected!r} is not advertised; use --model MODEL_ID")
    context = models[selected]["context_length"]
    ca_path = profile / "certs" / "provider.pem"
    environment = settings.setdefault("env", {})
    environment.update({
        "ANTHROPIC_BASE_URL": anthropic_url,
        "ANTHROPIC_AUTH_TOKEN": connection["api_key"],
        "NODE_EXTRA_CA_CERTS": str(ca_path),
        "CLAUDE_CODE_MAX_CONTEXT_TOKENS": str(context),
        "CLAUDE_CODE_MAX_OUTPUT_TOKENS": str(min(16384, context // 4)),
        "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
        # llama.cpp does not implement Anthropic's server-side classifier.
        # Keep Claude Code's client-side checks instead of probing that feature.
        "CLAUDE_CODE_AUTO_MODE_SERVER": "0",
    })
    # Keep internal small-model calls on the same model: no surprise swaps.
    for family in ("SONNET", "OPUS", "HAIKU", "FABLE"):
        environment[f"ANTHROPIC_DEFAULT_{family}_MODEL"] = selected
    environment["CLAUDE_CODE_SUBAGENT_MODEL"] = selected
    # One context override applies to the process, so change models via this launcher.
    settings["model"] = selected
    settings["availableModels"] = [selected]
    settings["modelPicker"] = {
        "replaceBuiltInOptions": True,
        "options": [{"model": selected, "label": selected,
                     "description": f"{base_url}; {context:,} token context"}],
    }
    # Undo only the two exact rules this updater previously generated. These
    # hid unsupported tools but also made auto mode treat web access as banned.
    permissions = settings.get("permissions", {})
    if migrate_web_policy and isinstance(permissions.get("deny"), list):
        permissions["deny"] = [rule for rule in permissions["deny"]
                               if rule not in ("WebSearch", "WebFetch")]
    if args.check:
        print(f"\nPreview only: {settings_path}; model {selected}; context {context:,}")
        return
    profile.mkdir(parents=True, exist_ok=True)
    profile.chmod(0o700)
    if settings_path.exists():
        backup = profile / "settings.json.bak"
        shutil.copy2(settings_path, backup)
        backup.chmod(0o600)
    atomic_write(ca_path, certificate)
    atomic_write(profile / "models.json", json.dumps(models, indent=2) + "\n")
    atomic_write(settings_path, json.dumps(settings, indent=2) + "\n")
    mcp_path = profile / "web-mcp.json"
    atomic_write(mcp_path, json.dumps({"mcpServers": {"local-web": {
        "type": "stdio", "command": sys.executable,
        "args": [str(Path(__file__).with_name("web_mcp.py").resolve())],
        "env": {"NODE_EXTRA_CA_CERTS": str(ca_path)},
    }}}, indent=2) + "\n")
    # Only migrate the rules generated by the old updater once; later deny
    # rules may be intentional user policy and must remain untouched.
    atomic_write(web_policy_marker, "Legacy generated web deny rules migrated.\n")
    # NODE_EXTRA_CA_CERTS must be present before the runtime starts.
    command = [sys.executable, str(Path(__file__).resolve()),
               "--profile-dir", str(profile), "--source", str(args.source.resolve()), "--launch", "--"]
    atomic_write(profile / "launch", "#!/bin/sh\nexec " + shlex.join(command) + ' "$@"\n')
    (profile / "launch").chmod(0o700)
    print(f"\nUpdated {settings_path}; model {selected}; context {context:,}")
    if args.launch:
        child_env = os.environ.copy()
        # These shell overrides would select another credential or transport.
        for key in ("ANTHROPIC_API_KEY", "CLAUDE_CODE_OAUTH_TOKEN",
                    "CLAUDE_CODE_USE_BEDROCK", "CLAUDE_CODE_USE_VERTEX",
                    "CLAUDE_CODE_USE_FOUNDRY"):
            child_env.pop(key, None)
        child_env.update(environment)
        child_env["CLAUDE_CONFIG_DIR"] = str(profile)
        sys.stdout.flush()
        normalize = connection.get("claude_normalize_system_messages", False)
        with bridge(anthropic_url, connection["api_key"], ca_path,
                    normalize=normalize) as (local_url, local_token):
            child_env["ANTHROPIC_BASE_URL"] = local_url
            child_env["ANTHROPIC_AUTH_TOKEN"] = local_token
            # Session settings take priority over saved/project env values. Keep
            # the token out of process arguments and remove this file on exit.
            with tempfile.NamedTemporaryFile(mode="w", suffix=".json", dir=profile) as session:
                json.dump({"env": {"ANTHROPIC_BASE_URL": local_url,
                                   "ANTHROPIC_AUTH_TOKEN": local_token}}, session)
                session.flush()
                print("Claude transport adapter" + (": normalizing system-message placement" if normalize else ""))
                sys.stdout.flush()
                result = subprocess.call(["claude", *forwarded, *tool_arguments(forwarded),
                                          "--settings", session.name,
                                          "--mcp-config", str(mcp_path)], env=child_env)
            return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=connection_source())
    parser.add_argument("--profile-dir", type=Path,
                        default=Path(os.environ.get("CUSTOM_LLM_CLAUDE_PROFILE", "~/.claude-custom")))
    parser.add_argument("--model", help="Model to save; otherwise preserve the profile's selection")
    parser.add_argument("--check", action="store_true", help="Preview without writing or launching")
    parser.add_argument("--launch", action="store_true", help="Sync then launch Claude Code")
    parser.add_argument("claude_args", nargs=argparse.REMAINDER, help="Claude arguments after --")
    try:
        return synchronize(parser.parse_args())
    except (OSError, ValueError, KeyError, TypeError) as error:
        parser.exit(1, f"Claude sync failed: {error}\n")


if __name__ == "__main__":
    sys.exit(main())
