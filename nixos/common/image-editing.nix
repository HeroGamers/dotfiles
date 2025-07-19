{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    blender
    # gimp # broken
    gimp3
    inkscape
  ];
}
