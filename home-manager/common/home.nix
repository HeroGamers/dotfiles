# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./zsh.nix
    ./tmux.nix

    # Theme
    ./theme.nix
  ];

  # Set your username
  home = lib.mkDefault {
    username = "hero";
    homeDirectory = "/home/hero";
  };

  programs = lib.mkDefault {
    # Emable git and put git config
    git = {
      enable = true;
      userName = "Marcus Sand";
      userEmail = "hero@herogamers.dev";
    };
    # Let home Manager install and manage itself.
    home-manager.enable = true;

    # Add stuff for your user as you see fit:
    neovim.enable = true;
  };
  # home.packages = with pkgs; [ steam ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Wayland, X, etc. support for session vars
  #systemd.user.sessionVariables = config.home-manager.users.hero.home.sessionVariables;
}
