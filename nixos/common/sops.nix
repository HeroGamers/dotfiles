{ inputs, ... }:
{
  # https://github.com/Mic92/sops-nix
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";

  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # Specification of the secrets.
  sops.secrets.ping = { };
}
