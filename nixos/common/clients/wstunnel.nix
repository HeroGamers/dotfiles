{ config, ... }:
{
  # Load the path prefix into /run/secrets
  sops.secrets."services/wstunnel/path_prefix" = {
    owner = config.users.users.hero.name;
  };
}
