{
  inputs,
  pkgs,
  config,
  ...
}: let
  kali_ferrofluid_wallpaper = pkgs.fetchurl {
    url = "https://gitlab.com/kalilinux/packages/kali-wallpapers/-/raw/kali/master/2024/backgrounds/kali/kali-ferrofluid-16x9.jpg";
    hash = "sha256-LyqagIeQAMDpyFuUYxxip3R1rVQHXXI50dQBoddY9os=";
  };
  lock_wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/6l/wallhaven-6lkyeq.png";
    hash = "sha256-YRcxOcDVHaEZNgQ+suCitgy2WSZIq0tH6T8sOB7J4EU=";
  };
  catppuccin_binaryninja_theme = pkgs.fetchurl {
    url = "https://github.com/catppuccin/binary-ninja/raw/d2a7dcd2b97c4170b93df2dfeba7c11dae5b9779/themes/catppuccin-macchiato.bntheme";
    hash = "sha256-7Yo8fFiWa8DXu0fQ5dzIQDaRdqBPaHqoE0sNg5fMgfE=";
  };
in {
  imports = [
    # Import Catpuccin
    inputs.catppuccin.homeModules.catppuccin
  ];

  # Nerdfont
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.meslo-lg
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.fantasque-sans-mono
  ];

  # Catpuccin options
  # https://nix.catppuccin.com/options/home-manager-options.html
  catppuccin = {
    enable = true;

    accent = "pink";
    flavor = "macchiato";

    btop = {
      enable = true;
      flavor = "${config.catppuccin.flavor}";
    };

    cursors = {
      enable = true;

      accent = "${config.catppuccin.accent}";
      flavor = "${config.catppuccin.flavor}";
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

    kvantum = {
      enable = true;

      accent = "${config.catppuccin.accent}";
      flavor = "${config.catppuccin.flavor}";
    };

    nvim = {
      enable = true;
      flavor = "${config.catppuccin.flavor}";
    };

    tmux = {
      enable = true;
      flavor = "${config.catppuccin.flavor}";
    };

    zellij = {
      enable = true;
      flavor = "${config.catppuccin.flavor}";
    };

    zsh-syntax-highlighting = {
      enable = true;
      flavor = "${config.catppuccin.flavor}";
    };

    kitty = {
      enable = true;
      flavor = "${config.catppuccin.flavor}";
    };

    mpv = {
      enable = true;

      accent = "${config.catppuccin.accent}";
      flavor = "${config.catppuccin.flavor}";
    };

    lazygit = {
      enable = true;

      accent = "${config.catppuccin.accent}";
      flavor = "${config.catppuccin.flavor}";
    };

    # firefox = {
    #   enable = true;

    #   accent = "${config.catppuccin.accent}";
    #   flavor = "${config.catppuccin.flavor}";
    # };

    dunst = {
      enable = true;
      flavor = "${config.catppuccin.flavor}";
    };

    vscode = {
      profiles.default = {
        enable = true;

        flavor = "${config.catppuccin.flavor}";
      };
    };

    yazi = {
      enable = true;

      accent = "${config.catppuccin.accent}";
      flavor = "${config.catppuccin.flavor}";
    };

    wlogout = {
      enable = true;

      accent = "${config.catppuccin.accent}";
      flavor = "${config.catppuccin.flavor}";
    };

    # Also enable for hyprland
    hyprland = {
      enable = true;

      accent = "${config.catppuccin.accent}";
      flavor = "${config.catppuccin.flavor}";
    };

    hyprlock = {
      enable = true;

      accent = "${config.catppuccin.accent}";
      flavor = "${config.catppuccin.flavor}";
    };

    waybar = {
      enable = true;
      flavor = "${config.catppuccin.flavor}";
    };
  };

  # Manual catppuccin themes
  home.file = {
    ".binaryninja/themes/catppuccin-macchiato.bntheme".source = "${catppuccin_binaryninja_theme}";
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    # platformTheme.name = "qt6ct"; # `qt.platformTheme.name` must be set to `"kvantum"` to use `qt.style.catppuccin`

    style = {
      name = "kvantum";
    };
  };

  programs = {
    hyprlock = {
      settings = {
        background = [
          {
            path = "${lock_wallpaper}";
            blur_passes = 2;
            blur_size = 4;
          }
        ];
      };
    };
  };

  services = {
    hyprpaper = {
      settings = {
        preload = ["${kali_ferrofluid_wallpaper}"];

        wallpaper = [
          ", ${kali_ferrofluid_wallpaper}"
        ];
      };
    };
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
