{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mindustry
  ];
}
