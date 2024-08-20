{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    aegisub
    kdenlive
    mkvtoolnix
    #(aegisub.override {
    #    #useBundledLuaJIT = true;
    #    #luajit = (luajit.withPackages(ps: with ps; [
    #    #    moonscript
    #    #]));
    #})
  ];
}
