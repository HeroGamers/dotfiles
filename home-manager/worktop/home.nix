{
  ...
}:
{
  imports = [
    # Global common Home Manager config
    ../common

    # WSL-specific Home Manager config
    ../common/wsl.nix

    # Security
    ../common/security.nix

    # Devlopment tools and settings
    ../common/development.nix
  ];

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.05";
  };
}
