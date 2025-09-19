{
  inputs,
  pkgs,
  config,
  ...
}: let
  sddm_wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/ex/wallhaven-exkqk8.jpg";
    hash = "sha256-HATmU/6OrfgeoPIeUca/QFk3lzKD9NcpJenXQjMgMlU=";
  };
in {
  imports = [
    # Import Catpuccin
    inputs.catppuccin.nixosModules.catppuccin
  ];

  catppuccin = {
    enable = true;

    accent = "pink";
    flavor = "macchiato";

    tty = {
      enable = true;

      flavor = "${config.catppuccin.flavor}";
    };

    sddm = {
      enable = true;

      accent = "${config.catppuccin.accent}";
      flavor = "${config.catppuccin.flavor}";

      background = "${sddm_wallpaper}";
    };
  };

  # Enable cache for the catppuccin flake
  nix.settings = {
    substituters = ["https://catppuccin.cachix.org"];
    trusted-public-keys = ["catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="];
  };

  environment.systemPackages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    (catppuccin-kde.override {
      accents = ["${config.catppuccin.accent}" "pink"];
      flavour = ["${config.catppuccin.flavor}" "macchiato"];
    })
  ];
}
