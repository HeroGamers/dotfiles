# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ pkgs, ... }:
{
  imports = [
    # Import the common configuration
    ../common

    # Workstation
    ../common/workstation.nix

    # Development
    ../common/development.nix

    # AI tooling
    ../common/ai-local.nix

    # WSL specific configuration
    ../common/wsl.nix

    ../common/wsl-cuda.nix
  ];

  # make home-manager as a module of nixos
  # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
  home-manager = {
    # The user configurations
    users.hero = import ../../home-manager/worktop;
  };

  networking.hostName = "worktop";

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    elastic-package # Elastic integrations development tool
    # keep-sorted end
  ];

  # Avoid Docker network conflicts
  virtualisation.docker.daemon.settings = {
    default-address-pools = [
      {
        base = "172.27.0.0/16";
        size = 24;
      }
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
