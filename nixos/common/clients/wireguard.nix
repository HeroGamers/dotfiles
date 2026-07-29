{ inputs, config, ... }:
{
  # Key for the client
  sops.secrets.wg-key-client = {
    sopsFile = "${inputs.self}/secrets/${config.networking.hostName}/wireguard.yaml";
    owner = config.users.users.hero.name;
  };
}
