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

    # Nerdfont
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "Meslo" "JetBrainsMono" "FiraCode" "DroidSansMono" "FantasqueSansMono" ]; })
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

    programs.kitty.catppuccin = {
        enable = true;
        flavor = "${config.catppuccin.flavor}";
    };

    programs.mpv.catppuccin = {
        enable = true;

        accent = "${config.catppuccin.accent}";
        flavor = "${config.catppuccin.flavor}";
    };

    programs.lazygit.catppuccin = {
        enable = true;

        accent = "${config.catppuccin.accent}";
        flavor = "${config.catppuccin.flavor}";
    };

    programs.waybar = {
        # Inspired/yeeted from https://github.com/rubyowo/dotfiles/blob/nixos/users/rei/confs/waybar/style.css
        style = ''
            * {
                font-family: FantasqueSansMono Nerd Font;
                font-size: 19px;
                min-height: 0;
            }

            window#waybar {
                background: transparent;
            }

            #workspaces {
                border-radius: 1rem;
                background-color: @surface0;
                margin-top: 1rem;
                margin: 3px 3px 0px 3px;
            }

            #workspaces button {
                color: @pink;
                border-radius: 1rem;
                padding-left: 6px;
                margin: 5px 0;
                box-shadow: inset 0 -3px transparent;
                transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.68);
                background-color: transparent;
            }

            #workspaces button.active {
                color: @flamingo;
                border-radius: 1rem;
            }

            #workspaces button:hover {
                color: @rosewater;
                border-radius: 1rem;
            }

            #tray,
            #network,
            #backlight,
            #clock,
            #battery,
            #pulseaudio,
            #custom-lock,
            #custom-power {
                background-color: @surface0;
                margin: 3px 3px 0px 3px;
                padding: 5px 5px 5px 5px;
                border-radius: 1rem;
            }

            #clock {
                color: @lavender;
            }

            #battery {
                color: @green;
            }

            #battery.charging {
                color: @green;
            }

            #battery.warning:not(.charging) {
                color: @red;
            }

            #network {
                color: @flamingo;
            }

            #backlight {
                color: @yellow;
            }

            #pulseaudio {
                color: @pink;
            }

            #pulseaudio.muted {
                color: @red;
            }

            #custom-power {
                border-radius: 1rem;
                color: @red;
                margin-bottom: 1rem;
            }

            #tray {
                border-radius: 1rem;
            }

            tooltip {
                background: @base;
                border: 1px solid @pink;
            }

            tooltip label {
                color: @text;
            }
        '';
        catppuccin = {
            enable = true;
            flavor = "${config.catppuccin.flavor}";
        };
    };
    
    # Also enable for hyprland
    wayland.windowManager.hyprland.catppuccin = {
        enable = true;

        accent = "${config.catppuccin.accent}";
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
