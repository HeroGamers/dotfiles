# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  lib,
  pkgs,
  options,
  ...
}:
{
  imports = [
    # Import Home Manager
    inputs.home-manager.nixosModules.home-manager

    # nix-index-database
    inputs.nix-index-database.nixosModules.nix-index

    # If you want to use modules your own flake exports (from modules/nixos):
    # inputs.self.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
      inputs.self.overlays.stable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Custom overlays for specific packages
      (final: prev: {
        #   hi = final.hello.overrideAttrs (oldAttrs: {
        #     patches = [ ./change-hello-to-hi.patch ];
        #   });
      })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = lib.mkDefault true;

      # Allow broken packages
      #allowBroken = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        # flake-registry = "";

        # Set users who can use nix
        trusted-users = [
          "root"
          "hero"
        ];

        # Automatically detect files in the store that have identical contents, and replace them with hard links to a single copy. This saves disk space.
        # Also makes rebuilds slower, from what I can read.
        auto-optimise-store = true;

        # Workaround for https://github.com/NixOS/nix/issues/9574
        # https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry
        # nix-path = lib.mkForce config.nix.nixPath; # lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";

        extra-substituters = [
          # "https://cache.nixos.org/" # already included by default
          # Enable cache for nix-community
          "https://nix-community.cachix.org"
          "https://cache.numtide.com"
          "https://numtide.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
          "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        ];
      };
      # Opinionated: disable channels
      channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

      # this is set automatically by nixpkgs.lib.nixosSystem but might be required
      # if one is not using that:
      # nixpkgs.flake.source = nixpkgs;

      # Enable automatic optimization of the Nix store.
      # https://wiki.nixos.org/wiki/Storage_optimization#Automatic
      optimise.automatic = true; # although likely not needed when auto-optimise-store is enabled

      # Enable automatic garbage collection of the Nix store.
      # https://wiki.nixos.org/wiki/Storage_optimization#Automation
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
    };

  # but NIX_PATH is still used by many useful tools, so we set it to the same value as the one used by this flake.
  # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  # https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry
  environment.etc."nix/path/nixpkgs".source = inputs.nixpkgs;
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = lib.mkDefault "en_DK.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = lib.mkDefault "da_DK.UTF-8";
      LC_IDENTIFICATION = lib.mkDefault "da_DK.UTF-8";
      LC_MEASUREMENT = lib.mkDefault "da_DK.UTF-8";
      LC_MONETARY = lib.mkDefault "da_DK.UTF-8";
      LC_NAME = lib.mkDefault "da_DK.UTF-8";
      LC_NUMERIC = lib.mkDefault "da_DK.UTF-8";
      LC_PAPER = lib.mkDefault "da_DK.UTF-8";
      LC_TELEPHONE = lib.mkDefault "da_DK.UTF-8";
      LC_TIME = lib.mkDefault "en_DK.UTF-8"; # English dates/times with EU conventions (24h, ISO week)
    };
  };

  # Define a user account.
  users.users = {
    hero = {
      # Don't forget to set a password with ‘passwd’.
      initialPassword = "HelloWorld!";
      isNormalUser = true;
      description = "Hero";
      extraGroups = [
        # keep-sorted start
        "dialout"
        "docker"
        "input" # for reading udev input devices
        "networkmanager"
        "wheel"
        "wireshark"
        # keep-sorted end
      ];
      # packages = with pkgs; [
      #   kdePackages.kate
      #   thunderbird
      # ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFB/OxGoBrNAtxcGI6XFrGWMr+8Wv53x2oTx6EzDBh7 hero@cutefemboy.com"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILcDL6unYUjlcviJ800amEkKz7pcDugey9f7l71rh0vL hacktop@herogamers.dev"
      ];
    };
  };

  security.sudo = {
    wheelNeedsPassword = false;

    # extraRules = [
    #   {
    #     users = [ "hero" ];
    #     commands = [
    #       {
    #         command = "ALL";
    #         options = [ "NOPASSWD" ];
    #       }
    #     ];
    #   }
    # ];
  };

  # make home-manager as a module of nixos
  # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };

  # Comma, with nix-index-database
  programs.nix-index-database.comma.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # keep-sorted start

    alejandra # A formatter for Nix files
    aria2
    # busybox
    # blueman # Bluetooth manager, primarily for the tray icon - done with service instead
    coreutils # Provides basic GNU utilities
    cowsay
    curl
    dig
    # dunst # defined in HM
    fastfetch
    file
    fish
    fzf
    git
    htop
    ipcalc
    jq
    # kitty # defined in hm
    kmod # for lsmod, modinfo, modprobe, etc.
    # lazygit # defined in hm
    libressl # netcat
    # libsForQt5.qt5ct # Qt5 Configuration Tool
    magic-wormhole # file transfer tool
    # mpv # defined in hm
    ncdu # NCurses Disk Usage
    # neofetch # deprecated
    net-tools
    # neovim # defined in hm
    # nix-index # using nix-index-database instead
    nix-output-monitor
    npins
    p7zip
    tldr
    tmux
    unrar
    vim # we use neovim, but vim has xxd which I use for hexdumps
    wget
    whois
    yazi # TUI file manager
    zsh

    util-linux
    findutils
    gnugrep
    gnused
    gawk
    procps
    iproute2
    inetutils
    nettools

    bash
    gnutar
    gzip
    bzip2
    xz
    diffutils
    patch
    file
    which

    e2fsprogs
    dosfstools
    ntfs3g
    parted

    openssh
    bind
    traceroute

    lsof
    usbutils
    pciutils

    # keep-sorted end
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
  programs.nix-ld.libraries = options.programs.nix-ld.libraries.default;

  # SSH Agent
  programs.ssh.startAgent = lib.mkDefault true;
  # GNOME Keyring (Secret Service) Agent
  services.gnome.gnome-keyring.enable = lib.mkDefault true;
  # GNOME SSH Agent needs to be disabled to avoid conflicts with the built-in SSH agent
  services.gnome.gcr-ssh-agent.enable = lib.mkDefault false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = lib.mkDefault false;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = lib.mkDefault "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = lib.mkDefault false;
    };
  };
}
