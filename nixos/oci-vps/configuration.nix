# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    # Import the common configuration
    ../common

    # Import the server configuration
    ../common/server.nix

    # Host specific configuration
    ./disko.nix

    # QEMU guest configuration
    (modulesPath + "/profiles/qemu-guest.nix")

    # Sops
    ./sops.nix

    # Servers
    ../common/servers/iodine.nix
    ../common/servers/wireguard.nix
    ../common/servers/caddy.nix
    ../common/servers/wstunnel.nix
  ];

  home-manager = {
    # The user configurations
    users.hero = import ../../home-manager/oci-vps;
  };

  networking.hostName = "oci-vps";

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "usbhid"
  ];

  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=ttyAMA0,115200"
    # Oracle Cloud often behaves better with classic eth0 naming.
    "net.ifnames=0"
  ];

  # https://wiki.nixos.org/wiki/Install_NixOS_on_Oracle_Cloud#NixOS_configuration.nix
  # DHCP should be fine for OCI.
  networking.useDHCP = true;

  # Termius public key for extra SSH access
  users.users.hero.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILPvpJMphT0ifXAk6N+RqBLP3Py0IrDB4HHo/8Px2yAE termius-iPwne@herogamers.dev"
  ];

  # Note: you also need to configure open ports in the Oracle Cloud web interface
  # (Virtual Cloud Network -> Security Lists -> Ingress Rules)
  # firewall = {
  #   # (both optional)
  #   logRefusedConnections = false;
  #   rejectPackets = true;
  # };

  system.stateVersion = "25.05";
}
