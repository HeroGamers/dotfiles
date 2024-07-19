{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
    environment.systemPackages = with pkgs; [
        docker
        (python3.withPackages (python-pkgs: [
            
        ]))
    ];
}