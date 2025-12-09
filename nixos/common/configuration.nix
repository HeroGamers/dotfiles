# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  lib,
  config,
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

    # Python
    ./python.nix

    # Theme
    ./theme.nix
  ];

  nixpkgs = lib.mkDefault {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Hackpkgs and pwndbg
      (final: prev: {
        inherit (inputs.hackpkgs.packages.${final.stdenv.hostPlatform.system}) binaryninja-personal;
        inherit (inputs.hackpkgs.packages.${final.stdenv.hostPlatform.system}) ida-pro;
        inherit (inputs.hackpkgs.packages.${final.stdenv.hostPlatform.system}) mstrings;
        inherit (inputs.pwndbg.packages.${final.stdenv.hostPlatform.system}) pwndbg;
        #   hi = final.hello.overrideAttrs (oldAttrs: {
        #     patches = [ ./change-hello-to-hi.patch ];
        #   });
      })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;

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
        # Workaround for https://github.com/NixOS/nix/issues/9574
        # https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry
        nix-path = lib.mkForce config.nix.nixPath; # lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";

        # Enable cache for nix-community
        substituters = [
          # "https://cache.nixos.org/" # already included by default
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      };
      # Opinionated: disable channels
      channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

      # this is set automatically by nixpkgs.lib.nixosSystem but might be required
      # if one is not using that:
      # nixpkgs.flake.source = nixpkgs;
    };

  # but NIX_PATH is still used by many useful tools, so we set it to the same value as the one used by this flake.
  # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  # https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry
  environment.etc."nix/path/nixpkgs".source = inputs.nixpkgs;
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    hero = {
      initialPassword = "HelloWorld!";
      isNormalUser = true;
      description = "Hero";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "dialout"
        "wireshark"
        "input" # for reading udev input devices
      ];
      # packages = with pkgs; [
      #   kdePackages.kate
      #   thunderbird
      # ];
      openssh.authorizedKeys.keys = [
        # TODO: Add authorized SSH keys
      ];
    };
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

  # git tmux neovim fish htop ranger wget curl binutils nasm gcc-multilib
  # g++-multilib libc6-dev-i386 libc6-dbg nmap libssl-dev libffi-dev gdb build-essential
  # ltrace strace ruby-rubygems python3 python3-gmpy2 python3-pip python3-dev python3-setuptools
  # ruby-full netcat-traditional autoconf libtool automake zsh-autosuggestions zsh-syntax-highlighting
  # zsh tldr bat ffmpeg imagemagick ncdu ipcalc
  environment.systemPackages = with pkgs; [
    alejandra # A formatter for Nix files
    # busybox
    # blueman # Bluetooth manager, primarily for the tray icon - done with service instead
    coreutils # Provides basic GNU utilities
    curl
    dig
    # dunst # defined in HM
    ffmpeg-headless
    fish
    fzf
    git
    htop
    imagemagick
    iodine
    ipcalc
    jq
    #kitty # defined in hm
    #lazygit # defined in hm
    libressl # netcat
    libsecret # for modifying secrets in keyring secret service
    # libsForQt5.qt5ct # Qt5 Configuration Tool
    macchanger
    magic-wormhole # file transfer tool
    #mpv # defined in hm
    nasm # Netwide Assembler, for assembly programming
    ncdu # NCurses Disk Usage
    neofetch
    #neovim # defined in hm
    # nix-index # using nix-index-database instead
    nix-output-monitor
    nss
    p7zip
    tldr
    tmux
    unrar
    yazi # TUI file manager
    wget
    whois
    zsh
    cowsay
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
  # ++ (with pkgs; [
  #   # Electron stuff
  #   # nix-alien-find-libs ./node_modules/electron/dist/electron
  #   alsa-lib.out at-spi2-atk.out cairo.out cups.lib dbus.lib expat.out gdk-pixbuf.out glib.out gtk3.out nspr.out nss.out pango.out xorg.libX11.out xorg.libXScrnSaver.out xorg.libXcomposite.out xorg.libXcursor.out xorg.libXdamage.out xorg.libXext.out xorg.libXfixes.out xorg.libXi.out xorg.libXrandr.out xorg.libXrender.out xorg.libXtst.out xorg.libxcb.out
  # ]);

  # SSH Agent
  programs.ssh.startAgent = lib.mkDefault true;

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
}
