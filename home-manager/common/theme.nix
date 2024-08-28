{
    inputs,
    pkgs,
    config,
    ...
}: {
    imports = [
        # Import Catpuccin
        inputs.catppuccin.homeManagerModules.catppuccin
    ];

    # Catpuccin options
    # https://nix.catppuccin.com/options/home-manager-options.html
    catppuccin = {
        enable = true;

        accent = "pink";
        flavor = "macchiato";

        pointerCursor = {
            enable = true;

            accent = "${config.catppuccin.accent}";
            flavor = "${config.catppuccin.flavor}";
        };
    };

    # `gtk.catppuccin.enable` and `gtk.catppuccin.gnomeShellTheme` are deprecated and will be removed in a future release.
    # The upstream port has been archived and support will no longer be provided.
    # Please see https://github.com/catppuccin/gtk/issues/262
    # gtk = {
    #     enable = true;

    #     catppuccin = {
    #         enable = true;

    #         accent = "${config.catppuccin.accent}";
    #         flavor = "${config.catppuccin.flavor}";
    #     };
    # };

    qt = {
        enable = true;
        platformTheme.name = "kvantum";

        style = {
            name = "kvantum";

            catppuccin = {
                enable = true;

                accent = "${config.catppuccin.accent}";
                flavor = "${config.catppuccin.flavor}";
            };
        };
    };

    programs.neovim.catppuccin = {
        enable = true;
        flavor = "${config.catppuccin.flavor}";
    };

    programs.tmux.catppuccin = {
        enable = true;
        flavor = "${config.catppuccin.flavor}";
    };

    programs.zsh.syntaxHighlighting.catppuccin = {
        enable = true;
        flavor = "${config.catppuccin.flavor}";
    };

    # For Gnome (though I use KDE, but might as well put it here :) )
    # From: https://www.reddit.com/r/NixOS/comments/18hdool/how_do_i_set_a_global_dark_theme_and_configure_gtk/
    # dconf.settings = {
    #     "org/gnome/desktop/background" = {
    #         picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
    #     };
    #     "org/gnome/desktop/interface" = {
    #         color-scheme = "prefer-dark";
    #     };
    # };
}
