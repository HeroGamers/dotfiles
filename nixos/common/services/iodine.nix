{ config, ... }:
let
  svc_domain = "i.${config.dotfiles.settings.services.domain}";

  iodine_ip = "172.16.10.1";
  iodine_ip_range = "24";
in
{
  sops.secrets."services/iodine/password" = {
    restartUnits = [ "iodined.service" ];
    owner = config.users.users.iodined.name;
    group = config.users.users.iodined.group;
  };

  services.iodine.server = {
    enable = true;
    domain = svc_domain;
    ip = "${iodine_ip}/${iodine_ip_range}";
    extraConfig = "-c";

    passwordFile = config.sops.secrets."services/iodine/password".path;
  };

  # HTTP(S) and SOCKS proxy for iodine clients
  services._3proxy = {
    enable = true;
    services = [
      {
        type = "proxy";
        bindAddress = "${iodine_ip}";
        bindPort = 8080;
        auth = [ "iponly" ];
        acl = [
          {
            rule = "allow";
            sources = [ "${iodine_ip}/${iodine_ip_range}" ];
          }
          { rule = "deny"; }
        ];
      }
      {
        type = "socks";
        bindAddress = "${iodine_ip}";
        bindPort = 1080;
        auth = [ "iponly" ];
        acl = [
          {
            rule = "allow";
            sources = [ "${iodine_ip}/${iodine_ip_range}" ];
          }
          { rule = "deny"; }
        ];
      }
    ];
  };

  # DNS server for iodine clients (DNS in DNS, lmao, blame iOS / Purple Haze)
  services.dnsmasq = {
    enable = true;
    settings = {
      listen-address = "${iodine_ip}";
      bind-interfaces = true;
      interface = "dns0";
      no-resolv = true;
      server = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
  };

  # Enable NAT to forward iodine traffic to the internet
  # Gives a big packet overhead due to routing all the traffic through the iodine server, but it works... kinda.
  # networking.nat = {
  #   enable = true;
  #   enableIPv6 = true;
  #   externalInterface = "eth0";
  #   internalInterfaces = [ "dns0" ];
  # };

  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 ];

  networking.firewall.interfaces."dns0".allowedUDPPorts = [ 53 ];
  networking.firewall.interfaces."dns0".allowedTCPPorts = [
    53
    8080
    1080
  ];
}
