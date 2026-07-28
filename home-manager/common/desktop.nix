{ config, lib, ... }:
{
  # You can import other home-manager modules here
  imports = [
    # Hyprland
    ./hyprland

    # Walker
    ./walker.nix

    # Screencapture
    ./screencapture.nix
  ];

  programs = {
    # keep-sorted start
    kitty.enable = lib.mkDefault true;
    mpv.enable = lib.mkDefault true;
    vscode.enable = lib.mkDefault true;
    # keep-sorted end
  };

  services = {
    # keep-sorted start
    dunst = {
      enable = lib.mkDefault false; # DMS has a built-in notification daemon
    };
    # keep-sorted end
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Propagate home.sessionVariables into the systemd user environment.
  # Required for UWSM: Hyprland runs as a systemd service and never sources ~/.profile.
  systemd.user.sessionVariables = config.home.sessionVariables;
}
