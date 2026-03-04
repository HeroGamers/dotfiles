{
  inputs,
  config,
  pkgs,
  ...
}:
let
  # Default config
  # https://github.com/AvengeMedia/DankMaterialShell/blob/master/quickshell/Common/SettingsData.qml
  # https://github.com/AvengeMedia/DankMaterialShell/blob/master/quickshell/Common/settings/SettingsStore.js
  # https://raw.githubusercontent.com/AvengeMedia/DankMaterialShell/refs/heads/master/quickshell/Common/settings/SettingsSpec.js
  # https://raw.githubusercontent.com/AvengeMedia/DankMaterialShell/refs/heads/master/quickshell/Common/settings/SessionSpec.js
  # DMS default bar widget lists (from SettingsSpec.js / SettingsData.qml defaults).
  # Defined here so we can append to them without re-typing the whole list.
  # Update these if you ever want to track upstream default changes explicitly.
  dmsDefault = {
    settings = {
      barConfigs = [
        {
          autoHide = false;
          autoHideDelay = 250;
          borderColor = "surfaceText";
          borderEnabled = false;
          borderOpacity = 1;
          borderThickness = 1;
          bottomGap = 0;
          centerWidgets = [
            "music"
            "clock"
            "weather"
          ];
          enabled = true;
          fontScale = 1;
          gothCornerRadiusOverride = false;
          gothCornerRadiusValue = 12;
          gothCornersEnabled = false;
          id = "default";
          innerPadding = 0;
          leftWidgets = [
            "launcherButton"
            "workspaceSwitcher"
            "focusedWindow"
          ];
          name = "Main Bar";
          noBackground = false;
          openOnOverview = false;
          popupGapsAuto = true;
          popupGapsManual = 4;
          position = 0;
          rightWidgets = [
            "systemTray"
            "clipboard"
            "cpuUsage"
            "memUsage"
            "notificationButton"
            "battery"
            "controlCenterButton"
          ];
          screenPreferences = [ "all" ];
          showOnLastDisplay = true;
          spacing = 4;
          squareCorners = false;
          transparency = 1;
          visible = true;
          widgetTransparency = 1;
          widgetPadding = 12;
        }
      ];
    };
  };

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
      dankBatteryAlerts.enable = true;
      dockerManager.enable = true;
      nixMonitor.enable = true;
    };

    # https://danklinux.com/docs/dankmaterialshell/nixos-flake#settings-home-manager-only
    # Mirrors what DMS does when you click dms://theme/install/catppuccin?flavor=macchiato&accent=pink
    session = {
      isLightMode = false; # Dark mode
      wallpaperPath = "${kali_ferrofluid_wallpaper}";

      hiddenTrayIds = [
        "remmina-icon"
        "flameshot::Flameshot"
      ];
    };

    settings = {
      # Registry themes use currentThemeName = "custom" + currentThemeCategory = "registry"
      currentThemeName = "custom";
      currentThemeCategory = "registry";
      # Path DMS uses after installing a registry theme
      customThemeFile = "${config.home.homeDirectory}/.config/DankMaterialShell/themes/catppuccin/theme.json";
      # Variant selections for multi-variant themes (flavor + accent per light/dark mode)
      showWorkspaceIndex = false; # Numeric index hidden — Japanese names shown instead
      showWorkspaceName = true; # Show workspace names (Japanese numerals) in the bar
      useAutoLocation = true; # Auto location from IP for weather widget
      osdAlwaysShowValue = true; # Show percentage in on screen display (OSD) for volume/brightness changes

      # Power Settings - Idle Inhibitor timeout
      acMonitorTimeout = 15 * 60; # 15 minutes
      acLockTimeout = 5 * 60; # 5 minutes
      batteryMonitorTimeout = 15 * 60; # 15 minutes
      batteryLockTimeout = 5 * 60; # 5 minutes

      # barConfigs is written verbatim to settings.json — the HM module does not
      # merge with DMS defaults, so we must declare it explicitly.
      # Use // to spread the full default bar config and only override rightWidgets.
      barConfigs =
        let
          defaultBar = builtins.head dmsDefault.settings.barConfigs;
        in
        [
          (
            defaultBar
            // {
              rightWidgets = [ "idleInhibitor" ] ++ defaultBar.rightWidgets;
              # (builtins.filter (w: w != "controlCenterButton") defaultBar.rightWidgets)
              # ++ [
              #   "idleInhibitor"
              #   "controlCenterButton"
              # ];
            }
          )
        ];

      # Theming
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

      # Font
      fontFamily = "JetBrainsMono Nerd Font";
      monoFontFamily = "JetBrainsMono Nerd Font Mono";
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
