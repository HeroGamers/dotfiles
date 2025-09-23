{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Import minegrub theme
    inputs.minegrub-theme.nixosModules.default
  ];

  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;

      # Theme
      minegrub-theme = {
        enable = true;
        splash = "I use Nix btw.";
        background = "background_options/1.8  - [Classic Minecraft].png";
        boot-options-count = 4;
      };
    };
  };
}
