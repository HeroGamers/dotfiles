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
    };

    # Prevent FPS drops from mismatched version of mesa drivers
    # https://github.com/hyprwm/Hyprland/issues/5148
    hardware.opengl = {
        package = pkgs-unstable.mesa.drivers;

        # if you also want 32-bit support (e.g for Steam)
        driSupport32Bit = true;
        package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
    };
}
