{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  options,
  ...
}: {
  # DNS over HTTPS (DoH)
  services.dnscrypt-proxy2 = {
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
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      server_names = ["cloudflare" "mullvad-doh"];

      # Local network forwarding rules
      # https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-forwarding-rules.txt
      forwarding_rules = "${../../services/networking/forwarding-rules.txt}";
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  # Networking stuff
  networking = lib.mkDefault {
    # Enable networking
    networkmanager = {
      enable = true;
      # Disable DNS over DHCP
      dns = "none";
    };

    # Use local nameservers
    nameservers = ["127.0.0.1" "::1"];

    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
  };

  # Disable resolvd (using dnscrypt-proxy2 instead)
  services.resolved.enable = lib.mkDefault false;
}
