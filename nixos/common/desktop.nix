# Desktop configuration for physical/baremetal NixOS installations
# This contains desktop-specific settings: display, audio, bluetooth, GUI apps, etc.
{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Hyprland
    ./hyprland.nix

    # Walker
    ./walker.nix

    # Mobile tethering (iOS)
    ./mobile-tethering.nix

    # DNS configuration
    ./dns.nix

    # Systemd services (graphical session)
    ./systemd-services.nix

    # Sysadmin tools (VMware, remote desktop)
    ./sysadmin.nix

    # Office work
    ./office.nix

    # Python
    ./python.nix

    # Theme
    ./theme.nix
  ];

  # Bootloader
  boot.loader = lib.mkDefault {
    systemd-boot.enable = lib.mkDefault true;
    efi.canTouchEfiVariables = true;
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = lib.mkDefault true;

  # Enable SDDM display manager - https://wiki.nixos.org/wiki/Wayland#Display_Managers
  services.displayManager.sddm.enable = lib.mkDefault true;
  # Enable the KDE Plasma Desktop Environment.
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
  services.pulseaudio.enable = false;
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

    wireplumber.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true; # enables the Blueman manager applet (tray icon, pairing, etc.)

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    touchpad = {
      clickMethod = "clickfinger";
      tapping = false;
    };
  };

  # Enable Tailscale
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # Install firefox.
  programs.firefox.enable = lib.mkDefault true;

  # Desktop-specific packages
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    brightnessctl # Backlight control
    grim # Screenshot utility for Wayland
    kdePackages.dolphin # File manager
    kdePackages.kio-extras # extra protocols support (sftp, fish and more)
    kdePackages.kio-fuse # to mount remote filesystems via FUSE
    kdePackages.plasma-workspace # for icons and XDG menu
    kdePackages.qt6ct # Qt6 Configuration Tool
    kdePackages.qtsvg # Qt SVG module
    # kdePackages.spectacle # only works in KDE (needs KWin) :c
    # kdePackages.xwaylandvideobridge # was removed on 1d584e3a90dc2154eba1edbd57e1dfc754e31697, dunno if this breaks Hyprland screen sharing
    keepassxc # also used for keyring secret service
    networkmanager # my beloved <3
    networkmanagerapplet # for waybar tray, nm-connection-editor
    obsidian
    openvpn
    pavucontrol # PulseAudio Volume Control, also works for PipeWire
    playerctl # CLI media player controller
    seahorse # GNOME Keyring GUI
    slurp # Select region utility for Wayland
    tor-browser
    trayscale # tray icon for Tailscale
    vlc
    # vscode # Managed in home-manager
    wev
    wireguard-tools
    wl-clipboard
    wofi
    # keep-sorted end
  ];

  environment.sessionVariables = {
    # Hint electron apps to use wayland:
    # https://wiki.nixos.org/wiki/Hyprland#Electron_applications_defaulting_to_X11_rather_than_Wayland
    NIXOS_OZONE_WL = "1";
    # Set GSK_RENDERER to "cairo" for better performance with Wayland apps using GTK4 (NVIDIA GPU)
    GSK_RENDERER = "cairo";
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

      plugins = [
        pkgs.networkmanager-iodine # for DNS tunneling with iodine
        pkgs.networkmanager-openvpn # for OpenVPN support in NetworkManager
      ];
    };

    # Open ports in the firewall.
    firewall = {
      # Or disable the firewall altogether.
      # enable = false;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ 22 ];
    };
  };

  # PAM auto-decrypt GNOME Keyring on login
  # https://wiki.nixos.org/wiki/Secret_Service#Auto-decrypt_on_login
  security.pam.services.login.enableGnomeKeyring = lib.mkDefault true;
}
