{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    discord-canary
    element-desktop
    signal-desktop
    # keep-sorted end
  ];
}
