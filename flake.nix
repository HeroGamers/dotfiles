{
  description = "Hero's config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # https://flake.parts/
    flake-parts.url = "github:hercules-ci/flake-parts";

    # https://github.com/nix-systems/nix-systems
    systems.url = "github:nix-systems/default";

    # keep-sorted start block=yes

    catppuccin.url = "github:catppuccin/nix"; # Has binary cache
    hackpkgs = {
      url = "git+ssh://git@github.com/HeroGamers/hackpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland"; # Has binary cache
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };
    minegrub-theme = {
      url = "github:Lxtharia/minegrub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-shell-wrapper = {
      url = "github:NixenBiksen/nix-shell-wrapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pwndbg.url = "github:pwndbg/pwndbg"; # Has binary cache
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker.url = "github:abenz1267/walker"; # Has binary cache

    # keep-sorted end
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
