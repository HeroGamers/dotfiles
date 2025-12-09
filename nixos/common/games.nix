{
  pkgs,
  ...
}:
{
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    # factorio-space-age
    mindustry
    # keep-sorted end
  ];

  # Xbox controller support
  hardware.xpadneo.enable = true; # Bluetooth
  hardware.xone.enable = true; # USB dongle

  # Prevent GC of Factorio
  # system.extraDependencies = [
  #   factorio-space-age.src
  # ];
}
