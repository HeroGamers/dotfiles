{ ... }:
{
  # https://wiki.nixos.org/wiki/Factorio
  # https://search.nixos.org/options?show=services.factorio.*
  # https://wiki.factorio.com/Multiplayer
  services.factorio = {
    enable = true;
    openFirewall = true;
    lan = true;

    admins = [ "HeroGamers" ];
  };
}
