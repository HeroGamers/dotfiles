{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # Enable pay-respects
  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true;
  };

  # Enable ripgrep
  programs.ripgrep.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Zellij
  programs.zellij = {
    enable = lib.mkDefault true;
    enableZshIntegration = lib.mkDefault true;
    exitShellOnExit = true;
    settings = {
      show_startup_tips = false;
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings =
      let
        inherit (config.catppuccin) accent flavor sources;
        colors = (lib.importJSON "${sources.palette}/palette.json").${flavor}.colors;
      in
      lib.importJSON ./config/zsh/prompt.omp.json
      // {
        palette = lib.mapAttrs (_: color: color.hex) colors // {
          accent = colors.${accent}.hex;
        };
      };
  };

  # Common order values:
  #   500 (mkBefore): Early initialization (replaces initExtraFirst)
  #   550: Before completion initialization (replaces initExtraBeforeCompInit)
  #   1000 (default): General configuration (replaces initExtra)
  #   1500 (mkAfter): Last to run configuration
  programs.zsh =
    let
      extraFirstInit = lib.mkOrder 1 ''
        # Load profiling module
        #zmodload zsh/zprof
      '';
      afterCompInit = lib.mkOrder 1100 ''
        # Load suggestions once the line editor is idle.
        autoload -Uz ${pkgs.zsh-defer}/share/zsh-defer/zsh-defer
        zsh-defer -d source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

        bindkey "''${key[Up]}" up-line-or-search
        bindkey "''${key[Down]}" down-line-or-search
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line
        bindkey "^[[3~" delete-char

        # Remote hosts may lack terminfo for Kitty or a Zellij pane.
        if [[ $TERM == xterm-kitty || -n $ZELLIJ ]]; then
          alias ssh='TERM=xterm-256color ssh'
        fi

        # uv + virtualenvs need LD_LIBRARY_PATH directly; keep it scoped to uv only.
        # https://wiki.nixos.org/wiki/Python#Running_Python_packages_which_requires_compilation_and/or_contains_libraries_precompiled_without_nix
        function uvld() {
          if [[ -n "''${NIX_LD_LIBRARY_PATH:-}" ]]; then
            LD_LIBRARY_PATH="''${NIX_LD_LIBRARY_PATH}''${LD_LIBRARY_PATH:+:''${LD_LIBRARY_PATH}}" command uv "$@"
          else
            command uv "$@"
          fi
        }

        # Define a function to use nix-shell-wrapper
        function nix_shell_wrapper() {
          ${
            inputs.nix-shell-wrapper.packages.${pkgs.stdenv.hostPlatform.system}.default
          }/bin/nix-shell-wrapper "$@"
        }
      '';
      lastInit = lib.mkOrder 9999 ''
        # Print ZSH profiling results on shell exit
        #zprof
      '';
    in
    {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      localVariables = {
        # Some optimizations from https://scottspence.com/posts/speeding-up-my-zsh-shell#plugin-management
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = 20;
        ZSH_AUTOSUGGEST_USE_ASYNC = 1;
      };

      initContent = lib.mkMerge [
        extraFirstInit
        afterCompInit
        lastInit
      ];

      shellAliases = {
        ll = "ls -l";
        update = "nixos-rebuild switch --accept-flake-config --sudo --log-format internal-json -v |& nom --json";
        update-sudo = "sudo bash -c 'nixos-rebuild switch --accept-flake-config --log-format internal-json -v |& nom --json'";
        update-offline = "nixos-rebuild switch --accept-flake-config --sudo --offline --option substitute false --log-format internal-json -v |& nom --json";
        # vi = "vim";
        # vim = "nvim";
        lg = "lazygit";
        ns = "nix_shell_wrapper";
        signal = "signal-desktop --password-store=gnome-libsecret";
        element = "element-desktop --password-store=gnome-libsecret";
      };

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      plugins = with pkgs; [
        # keep-sorted start block=yes
        {
          file = "nix-zsh-completions.plugin.zsh";
          name = "nix-zsh-completions";
          src = "${nix-zsh-completions}/share/zsh/plugins/nix";
        }
        # keep-sorted end
      ];

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "aliases"
          "docker"
          "docker-compose"
          "node"
          # "pip"
        ];
      };
    };
}
