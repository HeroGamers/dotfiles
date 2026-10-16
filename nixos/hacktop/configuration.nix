{ lib, pkgs, ... }: {
  imports = [
    # Import the common configuration
    ../common

    # Import the desktop configuration
    ../common/desktop.nix

    # Workstation
    ../common/workstation.nix

    # Security
    ../common/security.nix

    # Nvidia GPU
    ../common/nvidia.nix

    # Local AI
    # ./ai-local.nix

    # AI tooling
    ../common/ai.nix

    # Nvidia PRIME settings for hybrid graphics
    ./nvidia.nix

    # Development
    ../common/development.nix

    # Wine
    ../common/wine.nix

    # Virtualization
    ../common/virtualization.nix

    # Aegisub and other video tools
    ../common/video-editing.nix

    # Image editing
    ../common/image-editing.nix

    # Games
    ../common/games.nix

    # GRUB
    ../common/grub.nix

    # Chat
    ../common/chat.nix

    # Clients
    ../common/clients/wireguard.nix
    ../common/clients/wstunnel.nix
    ../common/clients/iodine.nix

    # SOPS
    ../common/sops.nix
    ./sops.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  # make home-manager as a module of nixos
  # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
  home-manager = {
    # The user configurations
    users.hero = import ../../home-manager/hacktop;
  };

  # Define your hostname.
  networking.hostName = "hacktop";

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    plexamp
    # keep-sorted end
  ];

  # Captive portals: dnscrypt-proxy can't resolve the portal before login, so
  # `captive-browser` opens a Chromium that resolves via the DHCP-provided DNS
  programs.captive-browser = {
    enable = true;
    interface = "wlp0s20f3";
    # Upstream default, but with ungoogled-chromium instead of chromium
    browser = lib.concatStringsSep " " [
      ''env XDG_CONFIG_HOME="$PREV_CONFIG_HOME"''
      (lib.getExe pkgs.ungoogled-chromium)
      "--user-data-dir=\${XDG_DATA_HOME:-$HOME/.local/share}/chromium-captive"
      ''--proxy-server="socks5://$PROXY"''
      ''--proxy-bypass-list="<-loopback>"''
      "--no-first-run"
      "--new-window"
      "--incognito"
      "--no-default-browser-check"
      "--disable-extensions"
      "--disable-sync"
      "--disable-background-networking"
      "http://cache.nixos.org/"
    ];
  };

  # Disable OpenSSH on the hacktop
  # services.openssh.enable = false;

  # Hacktop is using brtfs
  # https://wiki.nixos.org/wiki/Docker/en#Docker_on_btrfs
  virtualisation.docker.storageDriver = "btrfs";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
