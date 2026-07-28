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
    ./nvim
    ./zsh.nix
    # ./tmux.nix

    # Theme
    ./theme.nix
  ];

  # Set your username
  home = {
    username = lib.mkDefault "hero";
    homeDirectory = lib.mkDefault "/home/hero";

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
    # Emable git and put git config
    git = {
      enable = lib.mkDefault true;
      settings = {
        user.name = lib.mkDefault "Marcus Sand";
        user.email = lib.mkDefault "hero@herogamers.dev";
      };
      # evaluation warning: The default value of `programs.git.signing.format` has changed from `"openpgp"` to `null`.
      signing.format = lib.mkDefault null;
    };
    # Let home Manager install and manage itself.
    home-manager.enable = lib.mkDefault true;

    # Add stuff for your user as you see fit:

    # keep-sorted start

    btop.enable = lib.mkDefault true;
    lazygit.enable = lib.mkDefault true;
    neovim.enable = lib.mkDefault true;

    # keep-sorted end
  };
  # home.packages = with pkgs; [ steam ];
}
