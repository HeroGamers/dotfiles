{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tailscaleRouting;
in
{
  # 1. Define the options
  options.services.tailscaleRouting = {
    enable = lib.mkEnableOption "declarative Tailscale routing";

    advertiseExitNode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to advertise this machine as an exit node.";
    };

    advertiseRoutes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "192.168.1.0/24"
        "10.0.0.0/24"
      ];
      description = "List of subnets to advertise to the Tailnet.";
    };
  };

  # 2. Implement the service
  config = lib.mkIf cfg.enable {
    systemd.services.tailscale-routing = {
      description = "Enforce Tailscale routing settings";

      after = [ "tailscaled.service" ];
      wants = [ "tailscaled.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        ExecStart =
          let
            # Convert the list of strings into a comma-separated string
            routesStr = lib.concatStringsSep "," cfg.advertiseRoutes;

            # Explicitly set true/false and empty strings to overwrite stale state
            exitNodeFlag = "--advertise-exit-node=${if cfg.advertiseExitNode then "true" else "false"}";
            routesFlag = "--advertise-routes=${routesStr}";
          in
          "${pkgs.tailscale}/bin/tailscale set ${exitNodeFlag} ${routesFlag}";
      };
    };
  };
}
