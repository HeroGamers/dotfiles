{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.python;
in
{
  options.custom.python = {
    enable = lib.mkEnableOption "the shared Python environment";

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "with pkgs.python3Packages; [ requests numpy ]";
      description = ''
        Python packages to include in the shared interpreter. Definitions from
        development, security, and host modules are merged into one environment.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.python3.withPackages (_: lib.unique cfg.packages))
      pkgs.uv
    ];
  };
}
