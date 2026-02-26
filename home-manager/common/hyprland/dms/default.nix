{
  inputs,
  config,
  pkgs,
  ...
}:
let
  kali_ferrofluid_wallpaper = pkgs.fetchurl {
    url = "https://gitlab.com/kalilinux/packages/kali-wallpapers/-/raw/kali/master/2024/backgrounds/kali/kali-ferrofluid-16x9.jpg";
    hash = "sha256-LyqagIeQAMDpyFuUYxxip3R1rVQHXXI50dQBoddY9os=";
  };
in
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms-plugin-registry.modules.default
  ];

  # Deploy the catppuccin theme.json from the dms-plugin-registry flake source.
  # The flake input is a full git checkout, so the theme files are available directly.
  # DMS registry themes live at ~/.config/DankMaterialShell/themes/<id>/theme.json
  xdg.configFile."DankMaterialShell/themes/catppuccin/theme.json" = {
    source = "${inputs.dms-plugin-registry}/themes/catppuccin/theme.json";
  };

  # https://danklinux.com/docs/dankmaterialshell/nixos-flake#3-enable-dankmaterialshell
  programs.dank-material-shell = {
    enable = true;

    # https://danklinux.com/docs/dankmaterialshell/nixos-flake#feature-toggles
    systemd = {
      enable = true; # Systemd service for auto-start
      restartIfChanged = true; # Auto-restart dms.service when dank-material-shell changes
    };

    enableDynamicTheming = false; # Not needed — using a static registry theme

    # https://danklinux.com/docs/dankmaterialshell/nixos-flake#plugins
    # https://danklinux.com/plugins
    # For example, dms://plugin/install/dankBatteryAlerts has the ID dankBatteryAlerts.
    plugins = {
      # Simply enable plugins by their ID (from the registry)
      # dankBatteryAlerts.enable = true;
      # dockerManager.enable = true;
    };

    # https://danklinux.com/docs/dankmaterialshell/nixos-flake#settings-home-manager-only
    # Mirrors what DMS does when you click dms://theme/install/catppuccin?flavor=macchiato&accent=pink
    session = {
      isLightMode = false; # Dark mode
      wallpaperPath = "${kali_ferrofluid_wallpaper}";
    };

    settings = {
      # Registry themes use currentThemeName = "custom" + currentThemeCategory = "registry"
      currentThemeName = "custom";
      currentThemeCategory = "registry";
      # Path DMS uses after installing a registry theme
      customThemeFile = "${config.home.homeDirectory}/.config/DankMaterialShell/themes/catppuccin/theme.json";
      # Variant selections for multi-variant themes (flavor + accent per light/dark mode)
      showWorkspaceIndex = true; # Show workspace numbers in the bar

      registryThemeVariants = {
        catppuccin = {
          dark = {
            flavor = "macchiato";
            accent = "pink";
          };
          # macchiato is dark-only; latte is the light counterpart
          light = {
            flavor = "latte";
            accent = "pink";
          };
        };
      };
    };
  };

  wayland.windowManager.hyprland.settings = {
    source = [
      "~/.config/hypr/dms/colors.conf"
      "~/.config/hypr/dms/layout.conf"
      # "~/.config/hypr/dms/windowrules.conf"
      # "~/.config/hypr/dms/outputs.conf"
    ];
  };
}
