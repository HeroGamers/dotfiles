{
  pkgs,
  ...
}:
{
  imports = [
    # Global common Home Manager config
    ../common

    # WSL-specific Home Manager config
    ../common/wsl.nix

    # Devlopment tools and settings
    ../common/development.nix

    # SSH
    ./ssh.nix
  ];

  programs.zsh.shellAliases.omp-soc = "env NODE_EXTRA_CA_CERTS=/run/secrets/custom-llm-ca omp";

  # Manual-only service: model files and presets remain editable outside Nix.
  systemd.user.services.llama-laptop = {
    Unit.Description = "Laptop llama.cpp model router";
    Service = {
      Type = "simple";
      Environment = [
        "LD_LIBRARY_PATH=/usr/lib/wsl/lib"
        "LLAMA_CACHE=%h/.cache/llama.cpp/laptop-router"
      ];
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.cache/llama.cpp/laptop-router";
      ExecStart = "${
        pkgs.llama-cpp.override { cudaSupport = true; }
      }/bin/llama-server --models-preset %h/.config/llama.cpp/laptop-models.ini --models-max 2 --no-models-autoload --host 127.0.0.1 --port 8081 --cors-origins localhost";
      Restart = "no";
    };
    # No Install.WantedBy: start explicitly with systemctl or just.
  };

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.11";
  };
}
