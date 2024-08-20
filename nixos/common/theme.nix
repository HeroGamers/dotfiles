{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    # Import Catpuccin
    inputs.catppuccin.nixosModules.catppuccin
  ];

  environment.systemPackages = with pkgs; [
    (catppuccin-kde.override {
      accents = [ "${config.catppuccin.accent}" "pink" ];
      flavour = [ "${config.catppuccin.flavor}" "macchiato" ];
    })
  ];
}
