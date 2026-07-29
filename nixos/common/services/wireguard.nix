{ config, ... }:
{
  # PublicKey: e784IO8IPkTKO6sZSDZ4XVnZliEFQWp3Pt+cRfcGj1I=
  sops.secrets.wg-key-server = {
    # sopsFile = "${inputs.self}/secrets/oci-vps/wireguard.yaml";
    restartUnits = [ "systemd-networkd.service" ];
    # for permission, see man systemd.netdev
    mode = "640";
    owner = config.users.users.systemd-network.name;
    group = config.users.users.systemd-network.group;
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  # https://wiki.nixos.org/wiki/WireGuard#systemd.network
  networking.useNetworkd = true;

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "eth0";
    internalInterfaces = [ "wg0" ];
  };

  systemd.network = {
    enable = true;

    networks."50-wg0" = {
      matchConfig.Name = "wg0";

      networkConfig = {
        # do not use IPMasquerade,
        # unnecessary, causes problems with host ipv6
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };

      # WireGuard interface configuration for the server
      address = [
        # Fresh random ULA.
        "fdf1:80c2:33a9::1/64"
        # Some random 10.x space
        "10.133.70.1/24"
      ];
    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = 51820;

        # ensure file is readable by `systemd-network` user
        PrivateKeyFile = config.sops.secrets.wg-key-server.path;

        # To automatically create routes for everything in AllowedIPs,
        # add RouteTable=main
        RouteTable = "main";

        # FirewallMark marks all packets send and received by wg0
        # with the number 42, which can be used to define policy rules on these packets.
        FirewallMark = 42;
      };
      wireguardPeers = [
        {
          # Hero phone peer
          PublicKey = "stw2hI64qJsSKprakzd+ImYIeMPUlKsk+nExRbFx6kU=";
          AllowedIPs = [
            "fdf1:80c2:33a9::2/128"
            "10.133.70.2/32"
          ];

          # RouteTable can also be set in wireguardPeers
          # RouteTable in wireguardConfig will then be ignored.
          # RouteTable = 1000;
        }
      ];
    };
  };

}
