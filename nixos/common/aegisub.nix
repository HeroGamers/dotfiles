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
    #(aegisub.override {
    #    #useBundledLuaJIT = true;
    #    #luajit = (luajit.withPackages(ps: with ps; [
    #    #    moonscript
    #    #]));
    #})
  ];
}
