{
  inputs,
  pkgs,
  config,
  ...
}:
let
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
  user_avatar = pkgs.fetchurl {
    url = "https://i.imgur.com/edxQRm5.png";
    hash = "sha256-YURdAE1duVB9H0DdnRXJkYtvG3e1tr3Y6yivr0LP4K8=";
  };
in
{
  imports = [
    # Import Catpuccin
    inputs.catppuccin.homeModules.catppuccin
  ];

  # User avatar — DMS (and other apps, like AccountsService) read from ~/.face
  home.file.".face".source = user_avatar;

  # Nerdfont
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # keep-sorted start
    nerd-fonts.droid-sans-mono
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.noto
    noto-fonts-cjk-sans # For Chinese, Japanese and Korean characters - not included in Nerd Fonts
    noto-fonts-color-emoji # For color emoji - not included in Nerd Fonts
    # keep-sorted end
  ];

  # Catpuccin options
  # https://nix.catppuccin.com/options/home-manager-options.html
  catppuccin = {
    enable = true;
    cache.enable = true;

    accent = "pink";
    flavor = "macchiato";

    # keep-sorted start block=yes

    btop.enable = true;
    cursors.enable = true;
    # dunst.enable = true;
    element-desktop.enable = true;
    hyprland.enable = true;
    hyprlock.enable = true;
    kitty.enable = true;
    kvantum = {
      enable = true;
      # assertStyle = false; # To use qt6ct
    };
    lazygit.enable = true;
    mpv.enable = true;
    nvim.enable = true;
    tmux.enable = true;
    vscode = {
      profiles.default = {
        enable = true;
      };
    };
    waybar.enable = true;
    wlogout.enable = true;
    yazi.enable = true;
    zellij.enable = true;
    zsh-syntax-highlighting.enable = true;
    # keep-sorted end
  };

  # Manual catppuccin themes
  home.file = {
    ".binaryninja/themes/catppuccin-macchiato.bntheme".source = "${catppuccin_binaryninja_theme}";
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    # platformTheme.name = "qt6ct";

    style = {
      name = "kvantum";
    };

    # Okay, so, I finally found the fix to Dolphin and KDE - but it's cursed
    # add the following to ~/.config/kdeglobals (or ~/.config/dolphinrc)
    # Shoutout to https://www.reddit.com/r/hyprland/comments/1gobj8c/dolphin_file_manager_font_colors/ and https://danklinux.com/docs/dankmaterialshell/application-themes?_highlight=theme#dolphin-file-manager
    # ```
    # [UiSettings]
    # ColorScheme=CatppuccinMacchiatoPink
    # ```
    # I might be able to use https://wiki.nixos.org/wiki/KDE#Plasma-Manager in the future
    # Because, it seems that a lot of apps need to get access to write to the kdeglobals file, so making it read-only with HM might cause issues

    # qt6ctSettings = {
    #   Appearance = {
    #     style = "kvantum";
    #     icon_theme = "Papirus-Dark"; # breeze-dark
    #     standard_dialogs = "xdgdesktopportal"; # default
    #   };
    #   Fonts = {
    #     fixed = "\"DejaVuSansM Nerd Font Mono,12\""; # "NotoSans Nerd Font" or "Noto Sans"
    #     general = "\"DejaVu Sans,12\""; # "NotoSans Nerd Font" or "Noto Sans"
    #   };
    # };
  };

  # KDE apps (e.g. Dolphin) read widgetStyle from kdeglobals rather than QT_STYLE_OVERRIDE.
  # home-manager's qt.style.name no longer reliably writes this, so we set it explicitly
  # via kwriteconfig6 — the proper KDE tool that patches only this key, leaving the rest
  # of kdeglobals (and Dolphin's own runtime settings) untouched.
  # home.activation.setKvantumWidgetStyle = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
  #     --file kdeglobals --group KDE --key widgetStyle kvantum
  # '';

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
        wallpaper = [
          # Fallback wallpaper
          {
            monitor = "";
            path = "${kali_ferrofluid_wallpaper}";
          }
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

  gtk = {
    #   font = {
    #     name = "Roboto";
    #     size = 10;
    #     package = pkgs.roboto;
    #   };

    #   theme = {
    #     # IMPORTANT: must match the directory inside share/themes
    #     name = "Catppuccin-GTK-Pink-Dark-Compact-Macchiato";
    #     package = pkgs.magnetic-catppuccin-gtk.override {
    #       size = "compact";
    #       accent = [ config.catppuccin.accent ];
    #       tweaks = [ config.catppuccin.flavor ];
    #     };
    #   };

    # evaluation warning: The default value of `gtk.gtk4.theme` has changed from `config.gtk.theme` to `null`.
    gtk4.theme = config.gtk.theme;
    gtk3.theme = config.gtk.theme;
    gtk2.theme = config.gtk.theme;

    #   # gtk4.extraConfig = {
    #   #   gtk-xft-antialias = 1;
    #   #   gtk-xft-hinting = 1;
    #   #   gtk-xft-hintstyle = "hintslight";
    #   #   gtk-xft-rgba = "rgb";
    #   #   gtk-enable-event-sounds = 0;
    #   #   gtk-enable-input-feedback-sounds = 0;
    #   # };

    #   # gtk3.extraConfig = {
    #   #   gtk-xft-antialias = 1;
    #   #   gtk-xft-hinting = 1;
    #   #   gtk-xft-hintstyle = "hintslight";
    #   #   gtk-xft-rgba = "rgb";
    #   #   gtk-enable-event-sounds = 0;
    #   #   gtk-enable-input-feedback-sounds = 0;
    #   # };

    #   # gtk2.extraConfig = ''
    #   #   gtk-xft-antialias=1
    #   #   gtk-xft-hinting=1
    #   #   gtk-xft-hintstyle="hintslight"
    #   #   gtk-xft-rgba="rgb"
    #   #   gtk-enable-event-sounds=0
    #   #   gtk-enable-input-feedback-sounds=0
    #   # '';
  };
}
