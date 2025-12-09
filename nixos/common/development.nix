{
  pkgs,
  ...
}:
{
  # Enable docker
  virtualisation.docker = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    docker
    #electron
    #nodejs
    cmake
    # gnumake
    go
    # ninja
    # gdb  # use Pwndbg instead
    gradle # Gradle build tool for Java projects
    keep-sorted # Tool to keep lists sorted
    # ant
    maven # Apache Maven for Java projects
    nixd # Nix language server
    # nodejs-10_x
    jdk # newest LTS Java JDK
    # jekyll
    gcc
    rustup # Rust toolchain installer
    llvm
    # lld
    # lldb
    yamlfmt
    nixfmt # nix formatter as defined by RFC 0166, prev. nixfmt-rfc-style
    nixfmt-tree # treefmt nix formatter
  ];
}
