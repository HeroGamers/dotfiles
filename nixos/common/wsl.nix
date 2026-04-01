{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl.enable = true;
  wsl.defaultUser = "hero";

  # Disable OpenSSH server in WSL
  services.openssh.enable = lib.mkForce false;
}
