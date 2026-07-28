# Server configuration for server NixOS installations
# This contains server-specific settings: networking, services, etc.
{
  lib,
  ...
}:
{
  imports = [
  ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = lib.mkDefault true;
    efi.canTouchEfiVariables = lib.mkDefault true;
  };

  # environment.systemPackages = with pkgs; [
  # ];

  services.openssh = {
    enable = lib.mkForce true;
    openFirewall = true;
  };

  # Enable Tailscale
  # services.tailscale = {
  #   enable = true;
  #   useRoutingFeatures = "client";
  # };

  # Networking stuff
  networking = {
    # Open ports in the firewall.
    firewall = {
      # Or disable the firewall altogether.
      # enable = false;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}
