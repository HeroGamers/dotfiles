{
  lib,
  runCommand,
  python3,
  makeWrapper,
  commandSuffix ? "custom",
}:
let
  python = python3.withPackages (ps: [
    ps.pyyaml
    ps.mcp
    ps.ddgs
  ]);
in
runCommand "custom-llm-1.0.0"
  {
    nativeBuildInputs = [ makeWrapper ];
    meta = {
      description = "Claude Code and Hermes launchers for an OpenAI/Anthropic-compatible inference provider";
      mainProgram = "claude-${commandSuffix}";
      platforms = lib.platforms.unix;
    };
  }
  ''
    mkdir -p "$out/lib/custom-llm" "$out/bin"
    cp ${./src}/*.py "$out/lib/custom-llm/"
    makeWrapper ${python}/bin/python "$out/bin/claude-${commandSuffix}" \
      --add-flags "$out/lib/custom-llm/sync_claude.py --launch --"
    makeWrapper ${python}/bin/python "$out/bin/claude-${commandSuffix}-check" \
      --add-flags "$out/lib/custom-llm/sync_claude.py --check"
    makeWrapper ${python}/bin/python "$out/bin/claude-${commandSuffix}-sync" \
      --add-flags "$out/lib/custom-llm/sync_claude.py"
    makeWrapper ${python}/bin/python "$out/bin/hermes-${commandSuffix}-check" \
      --add-flags "$out/lib/custom-llm/sync_hermes.py --check"
    makeWrapper ${python}/bin/python "$out/bin/hermes-${commandSuffix}-sync" \
      --add-flags "$out/lib/custom-llm/sync_hermes.py"
    cat > "$out/bin/hermes-${commandSuffix}" <<EOF
    #!${python}/bin/python
    import os
    import subprocess
    import sys
    subprocess.run(["${python}/bin/python", "$out/lib/custom-llm/sync_hermes.py"], check=True)
    os.execvp("hermes", ["hermes", *sys.argv[1:]])
    EOF
    chmod +x "$out/bin/hermes-${commandSuffix}"
    ${python}/bin/python -c 'import yaml, ddgs; from mcp.server.mcpserver import MCPServer'
  ''
