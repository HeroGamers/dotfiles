{
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.libreoffice-qt # Qt based LibreOffice
    pkgs.pdftk
    # pkgs.texlive.combined.scheme-full # LaTeX full installation
  ];
}
