# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  # keep-sorted start

  autorecon = pkgs.callPackage ./by-name/au/autorecon { };
  binwalk2 = pkgs.callPackage ./by-name/bi/binwalk2 { };
  elastic-package = pkgs.callPackage ./by-name/el/elastic-package { };
  oscanner = pkgs.callPackage ./by-name/os/oscanner { };
  # peepdf = pkgs.callPackage ./by-name/pe/peepdf { };
  sliver = pkgs.callPackage ./by-name/sl/sliver { };
  tnscmd10g = pkgs.callPackage ./by-name/tn/tnscmd10g { };

  # keep-sorted end
}
