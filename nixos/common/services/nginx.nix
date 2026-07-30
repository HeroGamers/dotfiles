{ ... }:
{
  services.nginx = {
    enable = true;
    virtualHosts.localhost = {
      # enableACME = true;
      # forceSSL = true;
      locations."/" = {
        return = "200 '<html><body>It works</body></html>'";
        extraConfig = ''
          default_type text/html;
        '';
        # proxyPass = "http://localhost:8080";
        # proxyWebsockets = true; # Explicitly required for WebSockets
      };
    };
  };

  security.acme = {
    # Accept the CA’s terms of service. The default provider is Let’s Encrypt, you can find their ToS at https://letsencrypt.org/repository/.
    acceptTerms = true;
    # Optional: You can configure the email address used with Let's Encrypt.
    # This way you get renewal reminders (automated by NixOS) as well as expiration emails.
    defaults.email = "letsencrypt@herogamers.dev";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
