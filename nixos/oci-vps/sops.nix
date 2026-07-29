{ inputs, ... }:
{
  sops.secrets.wg-key-server = {
    sopsFile = "${inputs.self}/secrets/oci-vps/wireguard.yaml";
  };
}
