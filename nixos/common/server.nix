# Server configuration for server NixOS installations
# This contains server-specific settings: networking, services, etc.
{
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.self.nixosModules.tailscale-routing
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

  # Custom module for Tailscale daemon state
  services.tailscaleRouting = {
    enable = true;
    advertiseExitNode = true;
    advertiseRoutes = [ ];
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
