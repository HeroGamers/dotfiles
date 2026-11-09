# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ pkgs, inputs, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./windows-ca.nix

    # Import the common configuration
    ../common

    # Workstation
    ../common/workstation.nix

    # Development
    ../common/development.nix

    # AI tooling
    ../common/ai.nix
    ../common/ai-local.nix

    # WSL specific configuration
    ../common/wsl.nix

    ../common/wsl-cuda.nix
  ];

  # make home-manager as a module of nixos
  # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
  home-manager = {
    # The user configurations
    users.hero = import ../../home-manager/worktop;
  };

  networking.hostName = "worktop";

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets.custom-llm-api-key = {
    sopsFile = ../../secrets/worktop/llm.json;
    format = "json";
    key = "api_key";
    owner = "hero";
    mode = "0400";
  };

  sops.secrets.custom-llm-ca = {
    sopsFile = ../../secrets/worktop/llm-ca.json;
    format = "json";
    key = "ca_bundle";
    owner = "hero";
    mode = "0400";
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    elastic-package # Elastic integrations development tool
    # keep-sorted end
  ];

  # Avoid Docker network conflicts
  virtualisation.docker.daemon.settings = {
    default-address-pools = [
      {
        base = "172.27.0.0/16";
        size = 24;
      }
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
