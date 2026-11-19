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
    configFile = ./config/zsh/prompt.omp.json;
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
      completionInit = lib.mkOrder 570 ''
        # Keep a cached compdump and only rebuild it once per day.
        # Oh-My-Zsh would otherwise run compinit itself, so we disable that below.
        skip_compinit=1
        autoload -Uz compinit

        zcompdump="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-''${ZSH_VERSION}"
        zcompdump_day=""

        mkdir -p "''${zcompdump:h}"

        if [[ -r "$zcompdump" ]]; then
          zcompdump_day=$(date -d "@$(stat -c %Y "$zcompdump")" +%j 2>/dev/null)
        fi

        if [[ -z "$zcompdump_day" || "$(date +%j)" != "$zcompdump_day" ]]; then
          compinit -i -d "$zcompdump"
        else
          compinit -i -C -d "$zcompdump"
        fi
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

        # TODO: remove when https://github.com/zellij-org/zellij/issues/775 gets fixed
        export TERM="xterm-256color"

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
            history -a # Save command history before starting the shell
            ${
              inputs.nix-shell-wrapper.packages.${pkgs.stdenv.hostPlatform.system}.default
            }/bin/nix-shell-wrapper "$@"
            history -r # Reload command history after exiting the shell
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
        completionInit
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
          file = "F-Sy-H.plugin.zsh";
          name = "F-Sy-H";
          src = "${zsh-f-sy-h}/share/zsh/site-functions";
        }
        {
          file = "nix-zsh-completions.plugin.zsh";
          name = "nix-zsh-completions";
          src = "${nix-zsh-completions}/share/zsh/plugins/nix";
        }
        {
          file = "zsh-autocomplete.plugin.zsh";
          name = "zsh-autocomplete";
          src = "${zsh-autocomplete}/share/zsh-autocomplete";
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
          "direnv"
        ];
      };
    };
}
