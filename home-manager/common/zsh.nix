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
            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
            # p10k instant prompt
            P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
            [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
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