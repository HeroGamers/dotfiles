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

    # Desktop theme
    ./theme-desktop.nix
  ];

  home = {
    # Session variables — propagated to the systemd user environment via desktop.nix
    # so they're available to UWSM/Hyprland and all launched apps, not just terminal sessions.
    # Do NOT set these in hyprland.conf env = [] when using UWSM (set too late).
    # https://wiki.hypr.land/Configuring/Environment-variables/
    sessionVariables = {
      # Wayland backends
      QT_QPA_PLATFORM = lib.mkDefault "wayland;xcb"; # wayland with xcb fallback
      SDL_VIDEODRIVER = lib.mkDefault "wayland";
      XDG_SESSION_TYPE = lib.mkDefault "wayland";
      GDK_BACKEND = lib.mkDefault "wayland,x11,*"; # GTK: wayland, then x11, then any
      # Not needed, we only set hyprbars on floating
      # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # prevent double decorations with hyprbars
      # Cursor - set by UWSM
      # XCURSOR_SIZE = "24";
      # HYPRCURSOR_SIZE = "24";
      # Required for Java GUI apps (IntelliJ etc.) on tiling/compositing WMs
      _JAVA_AWT_WM_NONREPARENTING = lib.mkDefault "1";
      # Note: XDG_SESSION_TYPE, XCURSOR_SIZE, HYPRCURSOR_SIZE are managed by UWSM
    };
  };

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
