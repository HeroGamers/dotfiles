{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  cfg = config.programs.omp;
in
{
  imports = [ ./python.nix ];

  options.programs.omp.enable = lib.mkEnableOption "Oh My Pi and its browser and debugger tools";

  config = {
    programs.omp.enable = lib.mkDefault true;

    custom.python = lib.mkIf cfg.enable {
      enable = lib.mkDefault true;
      packages = [ pkgs.python3Packages.debugpy ];
    };

    environment.variables = lib.mkIf cfg.enable {
      PUPPETEER_CHROME_SKIP_DOWNLOAD = "true";
      PUPPETEER_EXECUTABLE_PATH = lib.getExe pkgs.ungoogled-chromium;
      PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "true";
    };

    environment.systemPackages = [
      pkgs.bubblewrap
      llmPkgs.claude-code
      llmPkgs.codex
      llmPkgs.hermes-agent
      llmPkgs.gemini-cli
      pkgs.codex-auth
    ]
    ++ lib.optionals cfg.enable [
      llmPkgs.omp
      pkgs.delve
      pkgs.gdb
      pkgs.llvmPackages.lldb
      pkgs.ungoogled-chromium
    ];
  };
}
