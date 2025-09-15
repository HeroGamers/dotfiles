{
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.libreoffice-qt # Qt based LibreOffice
    # pkgs.texlive.combined.scheme-full # LaTeX full installation
  ];
}
