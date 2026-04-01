{
  description = "Hero's config";

  inputs = {
    # Core Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # Flake Utilities
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";

    # Hyprland Ecosystem
    hyprland.url = "github:hyprwm/Hyprland"; # Has binary cache
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    # Tools and Utilities
    # keep-sorted start block=yes
    catppuccin.url = "github:catppuccin/nix"; # Has binary cache
    ctf-dl = {
      url = "github:HeroGamers/ctf-dl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ctf-man = {
      url = "github:HeroGamers/ctf-man/feat/library";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hackpkgs = {
      url = "git+ssh://git@github.com/HeroGamers/hackpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minegrub-theme = {
      url = "github:Lxtharia/minegrub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft = {
      # For nixos/common/gameservers/minecraft-gtnh.nix
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    nix-shell-wrapper = {
      url = "github:NixenBiksen/nix-shell-wrapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pwndbg.url = "github:pwndbg/pwndbg"; # Has binary cache
    # quickshell = {
    #   # Only needed for DMS when not using the DMS flake
    #   url = "git+https://git.outfoxxed.me/quickshell/quickshell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker.url = "github:abenz1267/walker"; # Has binary cache
    # keep-sorted end

    # WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem =
        { pkgs, ... }:
        {
          packages = import ./pkgs pkgs;

          treefmt = (import ./treefmt.nix) { inherit pkgs; };
        };

      flake = {
        overlays = import ./overlays { inherit inputs; };

        nixosModules = import ./modules/nixos;

        homeManagerModules = import ./modules/home-manager;

        nixosConfigurations = {
          # keep-sorted start block=yes

          hacktop = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
              ./nixos/hacktop
            ];
          };
          hero-desktop = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./nixos/hero-desktop
            ];
          };
          worktop = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./nixos/worktop
            ];
          };

          # keep-sorted end
        };

        homeConfigurations = {
          # keep-sorted start block=yes

          "hero@nothing" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home-manager/hacktop
            ];
          };

          # keep-sorted end
        };
      };
    };
}
