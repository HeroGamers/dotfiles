{
  inputs,
  pkgs,
  ...
}:
{
  # Module not in use - using HM instead.
  imports = [
    inputs.dms-plugin-registry.nixosModules.default
  ];

  # https://danklinux.com/docs/dankmaterialshell/nixos
  programs.dms-shell = {
    enable = true;

    # https://danklinux.com/docs/dankmaterialshell/nixos#using-quickshell-from-source
    quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;

    # https://danklinux.com/docs/dankmaterialshell/nixos#plugins
    plugins = {
      # Simply enable plugins by their ID (from the registry)
      dankBatteryAlerts.enable = true;
      dockerManager.enable = true;
    };
  };
}
