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
        ];

        oh-my-zsh = {
            enable = true;
            plugins = [ "git" "thefuck" "aliases" "docker" "docker-compose" "pip" "node" ];
            #theme = "powerlevel10k/powerlevel10k";
        };
    };
}