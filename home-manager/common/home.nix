# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ lib, ... }:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # inputs.self.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./nvim

    ./zsh.nix
    # ./tmux.nix

    # Theme
    ./theme.nix
  ];

  # Set your username
  home = {
    username = lib.mkDefault "hero";
    homeDirectory = lib.mkDefault "/home/hero";
  };

  programs = {
    # Emable git and put git config
    git = {
      enable = lib.mkDefault true;
      settings = {
        user.name = lib.mkDefault "Marcus Sand";
        user.email = lib.mkDefault "hero@herogamers.dev";
      };
      # evaluation warning: The default value of `programs.git.signing.format` has changed from `"openpgp"` to `null`.
      signing.format = lib.mkDefault null;
    };
    # Let home Manager install and manage itself.
    home-manager.enable = lib.mkDefault true;

    # Add stuff for your user as you see fit:

    # keep-sorted start

    btop.enable = lib.mkDefault true;
    lazygit.enable = lib.mkDefault true;
    neovim.enable = lib.mkDefault true;

    # keep-sorted end
  };
  # home.packages = with pkgs; [ steam ];
}
