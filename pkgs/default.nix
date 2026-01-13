# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  # keep-sorted start

  binwalk2 = pkgs.callPackage ./by-name/bi/binwalk2 { };
  elastic-package = pkgs.callPackage ./by-name/el/elastic-package { };
  # peepdf = pkgs.callPackage ./by-name/pe/peepdf { };

  # keep-sorted end
}
