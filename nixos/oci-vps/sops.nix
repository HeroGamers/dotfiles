{ inputs, config, ... }:
{
  sops.secrets.wg-key-server = {
    sopsFile = "${inputs.self}/secrets/${config.networking.hostName}/wireguard.yaml";
  };
}
