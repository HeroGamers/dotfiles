{ config, ... }:
{
  sops.secrets."services/iodine/password" = {
    restartUnits = [ "iodined.service" ];
    owner = config.users.users.iodined.name;
    group = config.users.users.iodined.group;
  };

  services.iodine.server = {
    enable = true;
    domain = "i.qs.ax";
    ip = "172.16.10.1/24";
    passwordFile = config.sops.secrets."services/iodine/password".path;
  };

  networking.firewall.allowedUDPPorts = [ 53 ];
}
