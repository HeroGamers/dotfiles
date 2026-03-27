{
  pkgs,
  ...
}:
{
  programs = {
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    gamescope.enable = true; # Steam Deck's game compositor for running games in a separate session
    gamemode.enable = true; # Optimise Linux system performance on demand
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    # factorio-space-age
    (heroic.override {
      extraPkgs =
        pkgs': with pkgs'; [
          gamescope
          gamemode
        ];
    })
    mindustry
    protonup-qt
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
