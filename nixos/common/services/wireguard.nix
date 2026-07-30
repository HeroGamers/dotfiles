{ config, lib, ... }:
let
  # Peers list
  peers = [
    {
      # hacktop, .2
      publicKey = "nGkE+6ljQ+VGq+TzUAXHK7cf5b/x10HzJpEqXaX2zEM=";
    }
    {
      # hero-desktop, .3
      publicKey = "XsRSGRksVHBH4HXhnwCNRcaDRXyI1upo1S9anMYkUBA=";
    }
    {
      # hero-phone, .4
      publicKey = "stw2hI64qJsSKprakzd+ImYIeMPUlKsk+nExRbFx6kU=";
    }
    {
      # unused, .5
      publicKey = "vPM2dANBAddnMsQCdv05fgfL07h2Awuph8GTAfDA+3M=";
    }
  ];

  ipv4_network_prefix = "10.133.70.";
  ipv6_network_prefix = "fdf1:80c2:33a9::";
in
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
        "${ipv6_network_prefix}1/64"
        # Some random 10.x space
        "${ipv4_network_prefix}1/24"
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

      # Automatically map over the list of peers
      wireguardPeers = lib.imap0 (index: peer: {
        PublicKey = peer.publicKey;
        AllowedIPs = [
          "${ipv6_network_prefix}${toString (index + 2)}/128"
          "${ipv4_network_prefix}${toString (index + 2)}/32"
        ];
      }) peers;
    };
  };
}
