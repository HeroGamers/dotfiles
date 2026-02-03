{ lib, ... }:
{

  programs = lib.mkDefault {
    # keep-sorted start
    vscode.enable = false;
    # keep-sorted end
  };

  # Symlink VSCode settings and extensions from home-manager managed locations
  # ref: https://discourse.nixos.org/t/nixos-in-wsl-how-to-install-vscode-extensions/55445/5
  # home.file.".vscode-server/data/Machine/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/Code/User/settings.json";
  # home.file.".vscode-server/extensions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.vscode/extensions";
}
