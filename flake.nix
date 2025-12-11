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

    # https://github.com/nix-systems/nix-systems
    systems.url = "github:nix-systems/default";

    # purely for setting inputs.flake-utils.follows for other flakes
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    # keep-sorted start block=yes

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hackpkgs = {
      url = "git+ssh://git@github.com/HeroGamers/hackpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
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
    nix-shell-wrapper = {
      url = "github:NixenBiksen/nix-shell-wrapper";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    pwndbg = {
      url = "github:pwndbg/pwndbg";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # keep-sorted end
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      # keep-sorted start
      catppuccin,
      hackpkgs,
      hyprland,
      hyprland-plugins,
      nixos-wsl,
      systems,
      treefmt-nix,
      # keep-sorted end
      ...
    }@inputs:
    let
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

      # Eval treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      # Custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = eachSystem (
        pkgs: import ./pkgs nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}
      );

      # Formatter for nix files, available through 'nix fmt'
      # Options include: 'alejandra', 'nixfmt', 'nixfmt-tree'
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);
      # for `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.check self;
      });

      # Custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#hostname'
      nixosConfigurations = {
        # keep-sorted start block=yes

        hacktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            # Load config for this device
            ./nixos/hacktop
          ];
        };
        hero-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Load config for this device
            ./nixos/hero-desktop
          ];
        };
        worktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Load config for this device
            ./nixos/worktop
          ];
        };

        # keep-sorted end
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#username@hostname'
      homeConfigurations = {
        # keep-sorted start block=yes

        # Replace with username@hostname
        "hero@nothing" = home-manager.lib.homeManagerConfiguration {
          # Home-manager requires 'pkgs' instance
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Replace x86_64-linux with architecture
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home-manager/hacktop
          ];
        };

        # keep-sorted end
      };
    };
}
