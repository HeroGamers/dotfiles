{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    discord-canary
    signal-desktop
    # keep-sorted end
  ];
}
