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
  in lib.mkDefault {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Bootloader.
  boot.loader = lib.mkDefault {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = lib.mkDefault true;

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
  # services.xserver.libinput.enable = true;

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
    neovim
    wget
    vscode
    git
    zsh
    tmux
    tldr
    ffmpeg-headless
    fish
    htop
    curl
    binutils
    nasm
    nmap
    pwntools
    pwndbg
    imagemagick
    ncdu
    ipcalc
    libressl # netcat
    patchelf
    one_gadget
    pwninit
  ];

  # Set shell to zsh globally
  users.defaultUserShell = pkgs.zsh;
  users.users.hero.shell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

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

  # Open ports in the firewall.
  networking.firewall = lib.mkDefault {
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ 22 ];
  };
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
