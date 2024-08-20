{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    blender
    gimp
    inkscape
  ];
}
