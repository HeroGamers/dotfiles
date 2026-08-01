{
  inputs,
  config,
  pkgs,
  ...
}:
{
  # Key for the client
  sops.secrets.wg-key-client = {
    sopsFile = "${inputs.self}/secrets/${config.networking.hostName}/wireguard.yaml";
    owner = config.users.users.hero.name;
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    wireguard-tools
    # keep-sorted end
  ];
}
