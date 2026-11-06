{
  pkgs,
  inputs,
  ...
}:

let
  llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  environment.systemPackages = [
    pkgs.bubblewrap
    llmPkgs.claude-code
    llmPkgs.codex
    llmPkgs.hermes-agent
    llmPkgs.gemini-cli
    llmPkgs.omp
    pkgs.codex-auth
  ];
}
