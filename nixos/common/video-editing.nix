{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mkvtoolnix
    aegisub
    ffmpeg
    #(aegisub.override {
    #    #useBundledLuaJIT = true;
    #    #luajit = (luajit.withPackages(ps: with ps; [
    #    #    moonscript
    #    #]));
    #})
  ];
}
