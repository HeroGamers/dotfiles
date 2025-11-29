{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # Hyprland
    ./hyprland

    # Walker
    ./walker.nix

    # Screencapture
    ./screencapture.nix
  ];

  programs = lib.mkDefault {
    kitty.enable = true;
    mpv.enable = true;
  };

  services = lib.mkDefault {
    dunst = {
      enable = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Wayland, X, etc. support for session vars
  #systemd.user.sessionVariables = config.home-manager.users.hero.home.sessionVariables;
}
