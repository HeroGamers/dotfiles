{
  inputs,
  pkgs,
  lib,
  ...
}: let
  # For the mesa driver possible mismatch
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  # Enable cache for the Hyprland flake
  # https://wiki.hyprland.org/Nix/Cachix/
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;

    # Use the package from the flake
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    # https://wiki.hypr.land/Useful-Utilities/Systemd-start/#uwsm
    withUWSM = true; # recommended for most users
  };

  # For Hyprlock to work with PAM
  #security.pam.services.hyprlock = {};

  # Prevent FPS drops from mismatched version of mesa drivers
  # https://github.com/hyprwm/Hyprland/issues/5148
  # updated from hardware.opengl -> hardware.graphics
  hardware.graphics = {
    package = pkgs-unstable.mesa;

    # if you also want 32-bit support (e.g for Steam)
    enable32Bit = true;
    package32 = pkgs-unstable.pkgsi686Linux.mesa;
  };

  # Screensharing support - should be default in Hyprland anyway, so maybe not enable this?
  # https://wiki.nixos.org/wiki/Hyprland#Screensharing
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  # };
}
