{ pkgs, ... }:
{
  # Enable docker
  virtualisation.docker = {
    enable = true;

    daemon.settings = {
      # default-address-pools = [
      #   {
      #     base = "10.200.0.0/16";
      #     size = 24;
      #   }
      # ];
      dns = [
        # "172.17.0.1"
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    antigravity
    cmake
    devenv
    docker
    # jekyll
    gcc
    # gnumake
    go
    nasm # Netwide Assembler, for assembly programming
    # ninja
    # gdb  # use Pwndbg instead
    gradle # Gradle build tool for Java projects
    # nodejs-10_x
    jdk # newest LTS Java JDK
    just
    just-lsp
    keep-sorted # Tool to keep lists sorted
    llvm
    # ant
    maven # Apache Maven for Java projects
    nixd # Nix language server
    nixfmt # nix formatter as defined by RFC 0166, prev. nixfmt-rfc-style
    nixfmt-tree # treefmt nix formatter
    # electron
    nodejs
    rustup # Rust toolchain installer
    # lld
    # lldb
    yamlfmt
    # keep-sorted end
  ];

  programs.nix-ld.libraries = with pkgs; [
    # Python
    # https://wiki.nixos.org/wiki/Python#Using_nix-ld
    zlib
    zstd
    stdenv.cc.cc
    curl
    openssl
    attr
    libssh
    bzip2
    libxml2
    acl
    libsodium
    util-linux
    xz
    systemd

    # Electron stuff
    # nix-alien-find-libs ./node_modules/electron/dist/electron
    #alsa-lib.out at-spi2-atk.out cairo.out cups.lib dbus.lib expat.out gdk-pixbuf.out glib.out gtk3.out nspr.out nss.out pango.out libx11.out libxscrnsaver.out libxcomposite.out libxcursor.out libxdamage.out libxext.out libxfixes.out libxi.out libxrandr.out libxrender.out libxtst.out libxcb.out
  ];

  nix.settings = {
    extra-substituters = [ "https://devenv.cachix.org" ];
    extra-trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
  };
}
