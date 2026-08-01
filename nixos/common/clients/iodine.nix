{ config, pkgs, ... }:
{
  # Load the password into /run/secrets
  sops.secrets."services/iodine/password" = {
    owner = config.users.users.hero.name;
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    iodine
    # keep-sorted end
  ];
}
