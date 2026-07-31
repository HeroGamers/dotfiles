{ ... }:
{
  imports = [
    # Import the common configuration
    ../common

    # Import the desktop configuration
    ../common/desktop.nix

    # Workstation
    ../common/workstation.nix

    # GRUB
    ../common/grub.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  # make home-manager as a module of nixos
  # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
  home-manager = {
    # The user configurations
    users.hero = import ../../home-manager/flareon;
  };

  # Define your hostname.
  networking.hostName = "flareon";

  # environment.systemPackages = with pkgs; [
  #   # keep-sorted start
  #   # keep-sorted end
  # ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
