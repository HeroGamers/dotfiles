{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  # Enable docker
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
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
    # ant
    maven # Apache Maven for Java projects
    # nodejs-10_x
    jdk # newest LTS Java JDK
    # jekyll
    gcc
    rustup # Rust toolchain installer
    llvm
    # lld
    # lldb
  ];
}
