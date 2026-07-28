{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.llm-agents.overlays.default ];

  # or "with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};"
  environment.systemPackages = with pkgs; [
    llm-agents.claude-code
    llm-agents.codex
    llm-agents.gemini-cli
  ];
}
