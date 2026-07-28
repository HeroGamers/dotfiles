# Desktop configuration for physical/baremetal NixOS installations
# This contains desktop-specific settings: display, audio, bluetooth, GUI apps, etc.
{
  lib,
  pkgs,
  ...
}:
{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    htop
  ];

  # Bootloader
  boot.loader = lib.mkDefault {
    systemd-boot.enable = lib.mkDefault true;
    efi.canTouchEfiVariables = true;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # Enable Tailscale
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # Networking stuff
  networking = lib.mkDefault {
    # Open ports in the firewall.
    firewall = {
      # Or disable the firewall altogether.
      # enable = false;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ 22 ];
    };
  };
}
