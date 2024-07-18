{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  # Define your hostname.
  networking.hostName = "hacktop";

  # Disable OpenSSH on the hacktop
  services.openssh.enable = false;
}