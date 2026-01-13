{
  python3Packages,
}:
let
  binwalk = with python3Packages; callPackage ../development/python-modules/binwalk { };
in

with python3Packages;
toPythonApplication binwalk
