{ config, ... }:
{
  services.iodine.server = {
    enable = true;
    domain = "i.qs.ax";
    ip = "172.16.10.1/24";
    passwordFile = config.sops.secrets."services.iodine.password".path;
  };
}
