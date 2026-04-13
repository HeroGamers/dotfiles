{ lib, ... }:
{
  # DNS over HTTPS (DoH)
  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      #ipv6_servers = true;
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      server_names = [
        "cloudflare"
        "mullvad-doh"
      ];

      # Local network forwarding rules
      # https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-forwarding-rules.txt
      forwarding_rules = "${../../services/networking/forwarding-rules.txt}";
    };
  };

  systemd.services.dnscrypt-proxy.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  # Networking stuff
  networking = lib.mkDefault {
    # Enable networking
    networkmanager = {
      enable = true;
      # We use split-DNS with systemd-resolved, so we need to tell NetworkManager to use systemd-resolved for DNS resolution
      # This helps us avoid issues with WG interfaces and their defined DNS servers
      dns = "systemd-resolved";
    };

    # Use local nameservers
    nameservers = [
      "127.0.0.1"
      "::1"
    ];

    search = [ "~." ];

    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
  };

  # Use resolved for DNS resolution, with dnscrypt-proxy as the upstream resolver (split-DNS)
  services.resolved = {
    enable = true;

    settings = {
      Resolve = {
        # DNSStubListenerExtra = "172.17.0.1"; # gateway of Docker pool

        # Default is config.networking.nameservers
        # DNS = [
        #   "127.0.0.1"
        #   "::1"
        # ];

        # Default is config.networking.search
        # Domains = ["~."]; # catch-all for split-DNS
      };
    };
  };
}
