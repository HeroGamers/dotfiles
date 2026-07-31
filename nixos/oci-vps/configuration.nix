# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  lib,
  ...
}:
{
  imports = [
    # Import the common configuration
    ../common

    # Import the server configuration
    ../common/server.nix

    # Hardware configuration
    ./hardware-configuration.nix

    # Disk configuration
    ./disko.nix

    # Sops
    ./sops.nix

    # Servers
    ../common/services/iodine.nix
    ../common/services/wireguard.nix
    ../common/services/caddy.nix
    ../common/services/wstunnel.nix
  ];

  home-manager = {
    # The user configurations
    users.hero = import ../../home-manager/oci-vps;
  };

  networking.hostName = "oci-vps";

  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=ttyAMA0,115200"
    # Oracle Cloud often behaves better with classic eth0 naming.
    "net.ifnames=0"
  ];

  # https://wiki.nixos.org/wiki/Install_NixOS_on_Oracle_Cloud#NixOS_configuration.nix
  # DHCP should be fine for OCI.
  networking.useDHCP = true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  # Termius public key for extra SSH access
  users.users.hero.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILPvpJMphT0ifXAk6N+RqBLP3Py0IrDB4HHo/8Px2yAE termius-iPwne@herogamers.dev"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDU+KXHuiJvd8lOM1nG3iBFdIQ3ZevmtfBXMrWYYtmv7 flareon@herogamers.dev"
  ];

  dotfiles.settings.services.domain = lib.mkForce "qs.ax";

  # Note: you also need to configure open ports in the Oracle Cloud web interface
  # (Virtual Cloud Network -> Security Lists -> Ingress Rules)
  # firewall = {
  #   # (both optional)
  #   logRefusedConnections = false;
  #   rejectPackets = true;
  # };

  system.stateVersion = "25.05";
}
