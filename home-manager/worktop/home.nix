{
  ...
}:
{
  imports = [
    # Global common Home Manager config
    ../common

    # WSL-specific Home Manager config
    ../common/wsl.nix

    # Devlopment tools and settings
    ../common/development.nix

    # SSH
    ./ssh.nix
  ];

  programs.zsh.shellAliases.omp-soc = "env NODE_EXTRA_CA_CERTS=/run/secrets/custom-llm-ca omp";

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.11";
  };
}
