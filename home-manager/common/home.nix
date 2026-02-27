# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ lib, ... }:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # inputs.self.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./zsh.nix
    ./tmux.nix

    # Theme
    ./theme.nix
  ];

  # Set your username
  home = lib.mkDefault {
    username = "hero";
    homeDirectory = "/home/hero";

    # Session variables — propagated to the systemd user environment via desktop.nix
    # so they're available to UWSM/Hyprland and all launched apps, not just terminal sessions.
    # Do NOT set these in hyprland.conf env = [] when using UWSM (set too late).
    # https://wiki.hypr.land/Configuring/Environment-variables/
    sessionVariables = {
      # Wayland backends
      QT_QPA_PLATFORM = "wayland;xcb"; # wayland with xcb fallback
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland,x11,*"; # GTK: wayland, then x11, then any
      # Not needed, we only set hyprbars on floating
      # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # prevent double decorations with hyprbars
      # Cursor - set by UWSM
      # XCURSOR_SIZE = "24";
      # HYPRCURSOR_SIZE = "24";
      # Required for Java GUI apps (IntelliJ etc.) on tiling/compositing WMs
      _JAVA_AWT_WM_NONREPARENTING = "1";
      # Note: XDG_SESSION_TYPE, XCURSOR_SIZE, HYPRCURSOR_SIZE are managed by UWSM
    };
  };

  programs = lib.mkDefault {
    # Emable git and put git config
    git = {
      enable = true;
      settings = {
        user.name = "Marcus Sand";
        user.email = "hero@herogamers.dev";
      };
    };
    # Let home Manager install and manage itself.
    home-manager.enable = true;

    # Add stuff for your user as you see fit:

    # keep-sorted start

    btop.enable = true;
    lazygit.enable = true;
    neovim.enable = true;

    # keep-sorted end
  };
  # home.packages = with pkgs; [ steam ];
}
