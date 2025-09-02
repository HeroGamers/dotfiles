{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  programs.steam.enable = true;
  
  environment.systemPackages = with pkgs; [
    # factorio-space-age
    mindustry
  ];

  # Prevent GC of Factorio
  # system.extraDependencies = [
  #   factorio-space-age.src
  # ];
}
