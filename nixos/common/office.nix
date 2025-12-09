{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    # keep-sorted start
    pkgs.libreoffice-qt # Qt based LibreOffice
    pkgs.pdftk
    # pkgs.texlive.combined.scheme-full # LaTeX full installation
    # keep-sorted end
  ];
}
