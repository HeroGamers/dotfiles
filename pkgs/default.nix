# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  # keep-sorted start

  binwalk2 = pkgs.callPackage ./binwalk2 { };
  elastic-package = pkgs.callPackage ./elastic-package { };
  # peepdf = pkgs.callPackage ./peepdf { };

  # keep-sorted end
}
