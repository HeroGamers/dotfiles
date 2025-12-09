{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    blender
    gimp
    inkscape
    # keep-sorted end
  ];
}
