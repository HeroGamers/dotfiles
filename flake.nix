{
  description = "Hero's config";

  inputs = {
    # Core Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-26.05";
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
    disko = {
      url = "github:nix-community/disko";
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
    llm-agents.url = "github:numtide/llm-agents.nix"; # This flake is only built and tested against its pinned nixpkgs-unstable input.
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

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://numtide.cachix.org"
      "https://cache.numtide.com"
      "https://devenv.cachix.org"
      "https://hyprland.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://cuda-maintainers.cachix.org"
      "https://pwndbg.cachix.org"
      "https://catppuccin.cachix.org"
      "https://walker.cachix.org"
      "https://walker-git.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "pwndbg.cachix.org-1:HhtIpP7j73SnuzLgobqqa8LVTng5Qi36sQtNt79cD3k="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
    ];
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem =
        { pkgs, ... }:
        let
          mkCrossShell =
            crossPkgs: targetName:
            crossPkgs.mkShell {
              packages = [
                crossPkgs.stdenv.cc
              ];
              shellHook = ''
                echo "Cross-Compile Development Environment (${targetName})"
                echo "Compiler: $CC"
              '';
            };
        in
        {
          packages = import ./pkgs pkgs;

          devShells = {
            default = pkgs.mkShell { };

            win64 = mkCrossShell pkgs.pkgsCross.mingwW64 "win64";
            win32 = mkCrossShell pkgs.pkgsCross.mingw32 "win32";

            linux-aarch64 = mkCrossShell pkgs.pkgsCross."aarch64-multiplatform" "linux-aarch64";
            linux-armv7 = mkCrossShell pkgs.pkgsCross."armv7l-hf-multiplatform" "linux-armv7";
            linux-riscv64 = mkCrossShell pkgs.pkgsCross.riscv64 "linux-riscv64";
            linux-musl64 = mkCrossShell pkgs.pkgsCross.musl64 "linux-musl64";
          };

          treefmt = (import ./treefmt.nix) { inherit pkgs; };
        };

      flake = {
        overlays = import ./overlays { inherit inputs; };

        nixosModules = import ./modules/nixos;

        homeManagerModules = import ./modules/home-manager;

        nixosConfigurations = {
          # keep-sorted start block=yes

          ctf-vm = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./nixos/ctf-vm
            ];
          };
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
          oci-vps = inputs.nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./nixos/oci-vps
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
