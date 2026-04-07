{
  python3Packages,
}:
let
  autorecon = with python3Packages; callPackage ../../../development/python-modules/autorecon { };
in

with python3Packages;
toPythonApplication autorecon
