{ pkgs, ... }:
{
  imports = [
    # Import the common configuration
    ../common

    # Import the desktop configuration
    ../common/desktop.nix

    # Security
    ../common/security.nix

    # Nvidia GPU
    ../common/nvidia.nix

    # Development
    ../common/development.nix

    # Wine
    ../common/wine.nix

    # Virtualization
    ../common/virtualization.nix

    # Aegisub and other video tools
    ../common/video-editing.nix

    # Image editing
    ../common/image-editing.nix

    # Games
    ../common/games.nix

    # GRUB
    ../common/grub.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  # make home-manager as a module of nixos
  # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
  home-manager = {
    # The user configurations
    users.hero = import ../../home-manager/hacktop;
  };

  # Define your hostname.
  networking.hostName = "hacktop";

  # Disable OpenSSH on the hacktop
  # services.openssh.enable = false;

  # Hacktop is using brtfs
  # https://wiki.nixos.org/wiki/Docker/en#Docker_on_btrfs
  virtualisation.docker.storageDriver = "btrfs";

  environment.systemPackages = with pkgs; [
    discord-canary
    signal-desktop
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
