{ inputs, pkgs, ... }:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  # Minecraft server settings
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/var/lib/minecraft-servers"; # Default is /srv/minecraft, but default for NixOS services is /var/lib, so I want to follow that convention

    # Code from:
    # https://github.com/Infinidoge/nix-minecraft/pull/147
    servers.gtnh = rec {
      server-port = 25566; # Default is 25565, but I want to run both the GTNH and regular servers at the same time ;p

      enable = true;
      package = pkgs.callPackage ./minecraft-gtnh-pkgs.nix { };
      jvmOpts = "-Xmx8G -Xms8G";
      serverProperties = {
        level-type = "rwg";
        difficulty = 3;
        allow-flight = true;
      };
      symlinks.mods = "${package}/lib/mods";
      files.config = "${package}/lib/config";
    };
  };
}
