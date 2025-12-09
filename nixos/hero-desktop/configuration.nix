# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  lib,
  ...
}:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default

    # Import the common configuration
    ../common

    # Security
    ../common/security.nix

    # Development
    ../common/development.nix

    # WSL specific configuration
    ../common/wsl.nix
  ];

  # make home-manager as a module of nixos
  # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
  home-manager = {
    # The user configurations
    users.hero = import ../../home-manager/hero-desktop;
  };

  networking.hostName = "hero-desktop";

  # Disable SSH agent in WSL (Windows handles this)
  programs.ssh.startAgent = lib.mkForce false;

  # Disable OpenSSH server in WSL
  services.openssh.enable = lib.mkForce false;

  # Exclude certain security packages in WSL
  custom.security.excludePackages = [
    "binaryninja-personal"
    "ida-pro"
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}
