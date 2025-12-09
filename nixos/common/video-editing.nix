{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    aegisub
    kdePackages.kdenlive
    mkvtoolnix
    # keep-sorted end
  ];
}
