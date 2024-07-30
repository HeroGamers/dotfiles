{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
    # Nerdfont
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "Meslo" "JetBrainsMono" "FiraCode" "DroidSansMono" ]; })
    ];

    # Enable thefuck
    programs.thefuck.enable = true;

    # Enable ZSH, oh-my-zsh and powerlevel10k
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        initExtra = ''
          bindkey "''${key[Up]}" up-line-or-search
          bindkey "''${key[Down]}" down-line-or-search
          bindkey "^[[H" beginning-of-line
          bindkey "^[[F" end-of-line
          bindkey "^[[3~" delete-char
        '';

        shellAliases = {
            ll = "ls -l";
            update = "sudo nixos-rebuild switch";
            vim = "nvim";
            lg = "lazygit";
        };

        history = {
            size = 10000;
            path = "${config.xdg.dataHome}/zsh/history";
        };

        initExtraBeforeCompInit = ''
            # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
            # Initialization code that may require console input (password prompts, [y/n]
            # confirmations, etc.) must go above this block; everything else may go below.
            P10K_INSTANT_PROMPT="''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
            if [[ -r "$P10K_INSTANT_PROMPT" ]]; then
              source "$P10K_INSTANT_PROMPT"
            fi
        '';

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
            plugins = [ "git" "thefuck" "aliases" "docker" "docker-compose" "pip" "node" ]; #"zsh-autosuggestions" "zsh-autocomplete" "F-Sy-H" ];
            #theme = "powerlevel10k/powerlevel10k";
        };
    };
}