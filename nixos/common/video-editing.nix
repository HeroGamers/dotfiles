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
    ffmpeg
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
