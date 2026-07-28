{ lib, ... }:
{
  programs.zellij = {
    enable = lib.mkForce false;
    enableZshIntegration = lib.mkForce false;
  };
}
