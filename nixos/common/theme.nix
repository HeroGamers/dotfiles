{
  inputs,
  pkgs,
  config,
  ...
}:
let
  sddm_wallpaper = pkgs.fetchurl {
    # https://www.monokuro.world/
    url = "https://w.wallhaven.cc/full/ex/wallhaven-exkqk8.jpg";
    hash = "sha256-HATmU/6OrfgeoPIeUca/QFk3lzKD9NcpJenXQjMgMlU=";
  };
in
{
  imports = [
    # Import Catpuccin
    inputs.catppuccin.nixosModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    cache.enable = true;

    accent = "pink";
    flavor = "macchiato";

    # keep-sorted start block=yes

    sddm = {
      enable = true;

      background = "${sddm_wallpaper}";
    };
    tty.enable = true;

    # keep-sorted end
  };

  # Enable cache for the catppuccin flake
  nix.settings = {
    substituters = [ "https://catppuccin.cachix.org" ];
    trusted-public-keys = [ "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU=" ];
  };

  environment.systemPackages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    (catppuccin-kde.override {
      accents = [
        "${config.catppuccin.accent}"
      ];
      flavour = [
        "${config.catppuccin.flavor}"
      ];
    })
  ];
}
