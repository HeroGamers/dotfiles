{ ... }:
{
  services.caddy = {
    enable = true;

    virtualHosts."localhost".extraConfig = ''
      tls internal
      respond "Hello, World!"
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
