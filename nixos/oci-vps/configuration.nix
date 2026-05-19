# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disko.nix

    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  networking.hostName = "oci-vps";

  # DHCP should be fine for OCI.
  networking.useDHCP = true;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  users.users.hero = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFB/OxGoBrNAtxcGI6XFrGWMr+8Wv53x2oTx6EzDBh7 hero@cutefemboy.com"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    htop
  ];

  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "25.05";
}
