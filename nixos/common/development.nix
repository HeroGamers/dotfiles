{ pkgs, ... }:
{
  # Enable docker
  virtualisation.docker = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    cmake
    devenv
    docker
    # jekyll
    gcc
    # gnumake
    go
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

  # Trusting devenv.cachix.org on first use with the public key devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
# Failed to set up binary caches:

#    https://devenv.cachix.org

# devenv is configured to automatically manage binary caches with `cachix.enable = true`, but cannot do so because you are not a trusted user of the Nix store.

# You have several options:

# a) To let devenv set up the caches for you, add yourself to the trusted-users list in /etc/nix/nix.conf by editing configuration.nix.

#      {
#        nix.settings.trusted-users = [ "root" "hero" ];
#      }

#    Rebuild your system:

#      $ sudo nixos-rebuild switch

# b) Add the missing binary caches to /etc/nix/nix.conf yourself by editing configuration.nix:

#      {
#        nix.extraOptions = ''
#          extra-substituters = https://devenv.cachix.org
#          extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
#        '';
#      }

#    Rebuild your system:

#      $ sudo nixos-rebuild switch

# c) Disable automatic cache management in your devenv configuration:

#      {
#        cachix.enable = false;
#      }

  # nix.extraOptions = ''
  #   extra-substituters = https://devenv.cachix.org
  #   extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  # '';

  nix.settings = {
    substituters = [ "https://devenv.cachix.org" ];
    trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
  };
}
