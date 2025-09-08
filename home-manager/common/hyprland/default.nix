{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./settings.nix
    ./binds.nix
    ./waybar
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    # Use the hyprland from the flake
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    # Extra configuration lines to add to ~/.config/hypr/hyprland.conf.
    # extraConfig = ''

    # '';

    # Replaced with UWSM
    # systemd = {
    #   # Enables hyprland-session.target on startup
    #   enable = true;

    #   # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
    #   variables = ["--all"];

    #   # First two lines from https://github.com/nix-community/home-manager/blob/e1391fb22e18a36f57e6999c7a9f966dc80ac073/modules/services/window-managers/hyprland.nix#L99-L102
    #   extraCommands = [
    #     "systemctl --user stop graphical-session.target"
    #     "systemctl --user start hyprland-session.target"
    #   ];
    # };

    # Enable xwayland (default true tho)
    xwayland.enable = true;

    # https://wiki.hyprland.org/Nix/Plugins/
    # From nixpkgs:
    # pkgs.hyprlandPlugins.<plugin>
    # From Flake:
    # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.<plugin>
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
      pkgs.hyprlock
      pkgs.hypridle
    ];
  };

  programs = {
    waybar = {
      enable = true;
    };
    wlogout = {
      enable = true;

      # Hyprland (UWSM) with hyprlock
      layout = [
        {
          label = "lock";
          # action = "loginctl lock-session";
          action = "hyprlock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
        }
        {
          label = "logout";
          # action = "loginctl terminate-user $USER";
          action = "hyprctl dispatch exit";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
    };
    hyprlock = {
      enable = true;
    };
  };

  services = {
    hypridle = {
      enable = true;

      settings = {
        general = {
          before_sleep_cmd = "hyprlock";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 5*60;
            on-timeout = "hyprlock";
          }
          {
            timeout = 15*60;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  # Enable gtk
  #gtk.enable = true;
}
