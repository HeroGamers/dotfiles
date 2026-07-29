{ inputs, config, ... }:
{
  # Load the path prefix into /run/secrets
  sops.secrets."services/wstunnel/path_prefix" = {
    owner = config.users.users.hero.name;
  };
  # And the key for the client too
  sops.secrets.wg-key-client = {
    sopsFile = "${inputs.self}/secrets/${config.networking.hostName}/wireguard.yaml";
    owner = config.users.users.hero.name;
  };
}
