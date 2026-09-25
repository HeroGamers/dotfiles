{ ... }:
{
  programs.ssh = {
    # The DefaultConfig for SSH is marked for deprecation
    enableDefaultConfig = false;
    # From https://github.com/nix-community/home-manager/blob/55730a2e34e71fafaf9b95eab98fb7b062b5f194/modules/programs/ssh.nix#L787
    settings."*" = {
      ForwardAgent = false;
      AddKeysToAgent = "no";
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };
  };
}
