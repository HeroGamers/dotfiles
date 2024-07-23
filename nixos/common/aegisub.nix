{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}:
{
  # https://nixos.wiki/wiki/Wine
  environment.systemPackages = with pkgs; [
    aegisub
    (lua.withPackages(ps: with ps; [
        busted luafilesystem moonscript
        ]))
  ];
}