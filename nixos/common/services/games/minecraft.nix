{ pkgs, ... }:
{
  # https://wiki.nixos.org/wiki/Minecraft_Server
  # https://search.nixos.org/options?show=services.minecraft-server.*
  services.minecraft-server = {
    enable = true;
    eula = true;
    package = pkgs.papermc;
    openFirewall = true; # Opens the port the server is running on (by default 25565)
    declarative = true;
    # whitelist = {
    #   # This is a mapping of Minecraft usernames to to the players' UUIDs
    #   username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    #   username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
    # };
    # https://minecraft.wiki/w/Server.properties#Java_Edition
    serverProperties = {
      # server-port = 43000;
      difficulty = 3; # hard
      gamemode = 0; # survival
      # max-players = 5;
      motd = "NixOS Minecraft server!";
      # white-list = true;
      allow-cheats = true;
    };
    # jvmOpts = "-Xms2048M -Xmx2048M";
  };
}
