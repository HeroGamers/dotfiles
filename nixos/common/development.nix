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
    # ninja
    # gdb
    # ant
    # maven
    # nodejs-10_x
    # jekyll
    gcc
    rustup
    llvm
    # lld
    # lldb
  ];
}
