{ config, ... }:
{
  sops.secrets."services/wstunnel/path_prefix" = {
    restartUnits = [ "caddy.service" ];
  };

  sops.templates."caddy-ws-path" = {
    owner = "caddy";
    group = "caddy";

    content = ''
      path /${config.sops.placeholder."services/wstunnel/path_prefix"} /${
        config.sops.placeholder."services/wstunnel/path_prefix"
      }/*
    '';
  };

  services.wstunnel = {
    enable = true;

    servers = {
      wg-tunnel = {
        enable = true;

        listen = {
          enableHTTPS = false; # handled by Caddy
          host = "127.0.0.1";
          port = 58213;
        };
        settings = {
          restrict-to = [
            {
              host = "127.0.0.1";
              port = 51820;
            }
            # For testing connectivity
            {
              host = "127.0.0.1";
              port = 22;
            }
          ];
          # restrict-http-upgrade-path-prefix = config.sops.secrets."services/wstunnel/password".path;
        };
      };
    };
  };

  services.caddy = {
    globalConfig = ''
      fallback_sni ws.qs.ax
    '';

    virtualHosts."ws.qs.ax".extraConfig = ''
      @ws {
        # Use the path prefix from the sops template
        import ${config.sops.templates."caddy-ws-path".path}
      }

      handle @ws {
        reverse_proxy 127.0.0.1:${toString config.services.wstunnel.servers.wg-tunnel.listen.port}
      }

      # Redirect all other requests
      handle {
        redir https://qs.ax
      }
    '';
  };
}
