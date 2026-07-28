{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ffmpeg-headless
    ghostscript
    imagemagick
  ];
}
