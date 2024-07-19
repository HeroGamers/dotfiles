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
        (python3.withPackages (python-pkgs: [
            
        ]))
    ];
}