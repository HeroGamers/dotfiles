{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    # Import Catpuccin
    inputs.catppuccin.nixosModules.catppuccin
  ];

  # Enable cache for the catppuccin flake
  nix.settings = {
    substituters = ["https://catppuccin.cachix.org"];
    trusted-public-keys = ["catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="];
  };

  environment.systemPackages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    (catppuccin-kde.override {
      accents = ["${config.catppuccin.accent}" "pink"];
      flavour = ["${config.catppuccin.flavor}" "macchiato"];
    })
  ];
}
