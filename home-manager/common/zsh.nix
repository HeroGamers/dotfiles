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
            ${inputs.nix-shell-wrapper.packages.x86_64-linux.default}/bin/nix-shell-wrapper "$@"
            history -r # Reload command history after exiting the shell
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
        update = "sudo sh -c 'nixos-rebuild switch --log-format internal-json -v |& nom --json'";
        vim = "nvim";
        lg = "lazygit";
        ns = "nix_shell_wrapper";
      };

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      plugins = with pkgs; [
        {
          file = "powerlevel10k.zsh-theme";
          name = "powerlevel10k";
          src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
        }
        {
          file = "p10k.zsh";
          name = "powerlevel10k-config";
          src = ./config/zsh/p10k;
        }
        {
          file = "F-Sy-H.plugin.zsh";
          name = "F-Sy-H";
          src = "${zsh-f-sy-h}/share/zsh/site-functions";
        }
        {
          file = "zsh-autocomplete.plugin.zsh";
          name = "zsh-autocomplete";
          src = "${zsh-autocomplete}/share/zsh-autocomplete";
        }
        {
          file = "nix-zsh-completions.plugin.zsh";
          name = "nix-zsh-completions";
          src = "${nix-zsh-completions}/share/zsh/plugins/nix";
        }
        {
          file = "zsh-autosuggestions.plugin.zsh";
          name = "zsh-autosuggestions";
          src = "${zsh-autocomplete}/share/zsh-autosuggestions";
        }
      ];

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "aliases"
          "docker"
          "docker-compose"
          "pip"
          "node"
          "direnv"
        ]; # "zsh-autosuggestions" "zsh-autocomplete" "F-Sy-H" ];
        #theme = "powerlevel10k/powerlevel10k";
      };
    };
}
