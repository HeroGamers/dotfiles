{ ... }:
{
  imports = [
    # Global common Home Manager config
    ../common

    # Desktop-specific Home Manager config
    ../common/desktop.nix

    # Development tools and settings
    ../common/development.nix

    # Security
    ../common/security.nix

    # Chat
    ../common/chat.nix

    # Monitors on Hyprland
    ./monitors.nix
  ];

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };
}
