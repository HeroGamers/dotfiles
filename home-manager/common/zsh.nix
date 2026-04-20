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
    enable = true;
    enableZshIntegration = true;
    exitShellOnExit = true;
    settings = {
      show_startup_tips = false;
    };
  };

  # Enable ZSH, oh-my-zsh and powerlevel10k
  programs.zsh =
    let
      beforeCompInit = lib.mkOrder 550 ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        P10K_INSTANT_PROMPT="''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        if [[ -r "$P10K_INSTANT_PROMPT" ]]; then
          source "$P10K_INSTANT_PROMPT"
        fi
      '';
      afterCompInit = lib.mkOrder 1000 ''
        bindkey "''${key[Up]}" up-line-or-search
        bindkey "''${key[Down]}" down-line-or-search
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line
        bindkey "^[[3~" delete-char

        # Define a function to use nix-shell-wrapper
        function nix_shell_wrapper() {
            history -a # Save command history before starting the shell
            ${
              inputs.nix-shell-wrapper.packages.${pkgs.stdenv.hostPlatform.system}.default
            }/bin/nix-shell-wrapper "$@"
            history -r # Reload command history after exiting the shell
        }

        function ctf() {
            local output exit_code nav_path temp_file

            # Temp file for navigation path
            temp_file="${"TMPDIR:-/tmp"}/ctf-man.path"

            # No arguments = TUI mode, run directly to preserve TTY
            if [ $# -eq 0 ]; then
                "${inputs.ctf-man.packages.${pkgs.stdenv.hostPlatform.system}.ctf-man}/bin/ctf-man"
                exit_code=$?

                # Check if navigation path was written to temp file
                if [ $exit_code -eq 0 ] && [ -f "$temp_file" ]; then
                    nav_path=$(cat "$temp_file")
                    rm -f "$temp_file"

                    if [ -d "$nav_path" ]; then
                        cd "$nav_path" || return 1
                    fi
                fi

                return $exit_code
            fi

            # CLI mode - capture output for error handling
            output=$("${
              inputs.ctf-man.packages.${pkgs.stdenv.hostPlatform.system}.ctf-man
            }/bin/ctf-man" "$@" 2>&1)
            exit_code=$?

            if [ $exit_code -eq 0 ]; then
                # Check temp file for navigation path
                if [ -f "$temp_file" ]; then
                    nav_path=$(cat "$temp_file")
                    rm -f "$temp_file"

                    if [ -d "$nav_path" ]; then
                        echo "Created and entering: $nav_path"
                        cd "$nav_path" || return 1
                    fi
                else
                    printf '%s\n' "$output"
                fi
            else
                printf '%s\n' "$output" >&2
                return $exit_code
            fi
        }
      '';
    in
    {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initContent = lib.mkMerge [
        beforeCompInit
        afterCompInit
      ];

      shellAliases = {
        ll = "ls -l";
        update = "sudo bash -c 'nixos-rebuild switch --log-format internal-json -v |& nom --json'";
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
          file = "p10k.zsh";
          name = "powerlevel10k-config";
          src = ./config/zsh/p10k;
        }
        {
          file = "powerlevel10k.zsh-theme";
          name = "powerlevel10k";
          src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
        }
        {
          file = "zsh-autocomplete.plugin.zsh";
          name = "zsh-autocomplete";
          src = "${zsh-autocomplete}/share/zsh-autocomplete";
        }
        {
          file = "zsh-autosuggestions.plugin.zsh";
          name = "zsh-autosuggestions";
          src = "${zsh-autocomplete}/share/zsh-autosuggestions";
        }
        # keep-sorted end
      ];

      oh-my-zsh = {
        enable = true;
        plugins = [
          # keep-sorted start
          "aliases"
          "direnv"
          "docker"
          "docker-compose"
          "git"
          "node"
          "pip"
          # keep-sorted end
        ];
        #theme = "powerlevel10k/powerlevel10k";
      };
    };
}
