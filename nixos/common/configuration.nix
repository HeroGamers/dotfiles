# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  home-manager,
  options,
  nixpkgs,
  ...
}: {
  imports = [
    # Import Home Manager
    inputs.home-manager.nixosModules.home-manager

    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    ./python.nix

    # Theme
    ./theme.nix

    # Systemd services
    ./systemd-services.nix
  ];

  nixpkgs = lib.mkDefault {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      # flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      # https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry
      nix-path = lib.mkForce config.nix.nixPath; # lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # but NIX_PATH is still used by many useful tools, so we set it to the same value as the one used by this flake.
  # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  # https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry
  environment.etc."nix/path/nixpkgs".source = inputs.nixpkgs;
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

  # Bootloader.
  boot.loader = lib.mkDefault {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n = lib.mkDefault {
    defaultLocale = "en_DK.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "da_DK.UTF-8";
      LC_IDENTIFICATION = "da_DK.UTF-8";
      LC_MEASUREMENT = "da_DK.UTF-8";
      LC_MONETARY = "da_DK.UTF-8";
      LC_NAME = "da_DK.UTF-8";
      LC_NUMERIC = "da_DK.UTF-8";
      LC_PAPER = "da_DK.UTF-8";
      LC_TELEPHONE = "da_DK.UTF-8";
      LC_TIME = "da_DK.UTF-8";
    };
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = lib.mkDefault true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = lib.mkDefault true;
  services.desktopManager.plasma6.enable = lib.mkDefault true;

  # Configure keymap in X11
  services.xserver = {
    xkb = lib.mkDefault {
      layout = "dk";
      variant = "winkeys";
    };
  };

  # Configure console keymap
  console.keyMap = lib.mkDefault "dk-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    touchpad = {
      clickMethod = "clickfinger";
      tapping = false;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    hero = {
      initialPassword = "HelloWorld!";
      isNormalUser = true;
      description = "Hero";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      packages = with pkgs; [
        kdePackages.kate
      #  thunderbird
      ];
      openssh.authorizedKeys.keys = [
        # TODO: Add authorized SSH keys
      ];
    };
  };
  
  # make home-manager as a module of nixos
  # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  # Install firefox.
  programs.firefox.enable = lib.mkDefault true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # git tmux neovim fish htop ranger wget curl binutils nasm gcc-multilib 
  # g++-multilib libc6-dev-i386 libc6-dbg nmap libssl-dev libffi-dev gdb build-essential
  # ltrace strace ruby-rubygems python3 python3-gmpy2 python3-pip python3-dev python3-setuptools
  # ruby-full netcat-traditional autoconf libtool automake zsh-autosuggestions zsh-syntax-highlighting
  # zsh tldr bat ffmpeg imagemagick ncdu ipcalc
  environment.systemPackages = with pkgs; [
    busybox
    curl
    dig
    ffmpeg-headless
    fish
    fzf
    git
    htop
    imagemagick
    ipcalc
    lazygit
    libressl # netcat
    macchanger
    mpv
    nasm
    ncdu
    neovim
    nix-index
    openssh
    openvpn
    p7zip
    rdesktop
    tigervnc
    tldr
    tmux
    tor-browser
    unrar
    vlc
    vscode
    wget
    whois
    wireguard-tools
    wl-clipboard
    zsh
  ];

  # Set shell to zsh globally
  users.defaultUserShell = pkgs.zsh;
  users.users.hero.shell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

  # Enable LD
  programs.nix-ld.enable = true;
  ## If needed, you can add missing libraries here. nix-index-database is your friend to
  ## find the name of the package from the error message:
  ## https://github.com/nix-community/nix-index-database
  programs.nix-ld.libraries = options.programs.nix-ld.libraries.default ++ (with pkgs; [ 
    # Electron stuff
    # nix-alien-find-libs ./node_modules/electron/dist/electron
    # alsa-lib.out at-spi2-atk.out cairo.out cups.lib dbus.lib expat.out gdk-pixbuf.out glib.out gtk3.out nspr.out nss.out pango.out xorg.libX11.out xorg.libXScrnSaver.out xorg.libXcomposite.out xorg.libXcursor.out xorg.libXdamage.out xorg.libXext.out xorg.libXfixes.out xorg.libXi.out xorg.libXrandr.out xorg.libXrender.out xorg.libXtst.out xorg.libxcb.out
  ]);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = lib.mkDefault {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

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
      server_names = [ "cloudflare" "mullvad-doh" ];

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

    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager = {
      enable = true;
      # Disable DNS over DHCP
      dns = "none";
    };

    # Use local nameservers
    nameservers = [ "127.0.0.1" "::1" ];

    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";

    # Open ports in the firewall.
    firewall = {
      # Or disable the firewall altogether.
      # enable = false;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ 22 ];
    };
  };

  # And disable resolvd
  services.resolved.enable = lib.mkDefault false;
  
}
