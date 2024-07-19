{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
    imports = [
        # Global common Home Manager config
        ../common

        # Security
        ../common/security.nix
    ];

    home = {
        # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
        stateVersion = "24.05";
    };
}