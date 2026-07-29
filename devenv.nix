{ pkgs, ... }:
{
  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.nix-output-monitor
    pkgs.sops
  ];

  # https://devenv.sh/languages/
  languages.nix.enable = true;

  devcontainer = {
    enable = true;
    settings.customizations.vscode.extensions = [ "jnoortheen.nix-ide" ];
  };

  # https://devenv.sh/scripts/
  scripts = {
    # https://nix.dev/manual/nix/latest/package-management/garbage-collection
    gc.exec = ''
      nix-collect-garbage --delete-older-than 7d
    '';
    sudo-update.exec = ''
      sudo bash -c 'nixos-rebuild switch --accept-flake-config --log-format internal-json -v |& nom --json'
    '';
    update.exec = ''
      nixos-rebuild switch --accept-flake-config --elevate=sudo --log-format internal-json -v |& nom --json
    '';
  };

  # https://devenv.sh/basics/
  enterShell = ''
    echo Welcome to the dotfiles development environment!
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks.nixfmt.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
