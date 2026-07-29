{ config, ... }:
{
  # Load the password into /run/secrets
  sops.secrets."services/iodine/password" = {
    owner = config.users.users.hero.name;
  };
}
