{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.llm-agents.overlays.default ];

  nix.settings = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  # or "with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};"
  environment.systemPackages = with pkgs; [
    llm-agents.claude-code
    llm-agents.codex
    llm-agents.gemini-cli
  ];
}
