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
  services.tailscale = {
    enable = lib.mkDefault true;
    useRoutingFeatures = lib.mkDefault "server";
    openFirewall = lib.mkDefault true;
  };

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
