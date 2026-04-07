{
  lib,
  stdenv,
  fetchFromGitLab,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "oscanner";
  version = "1.0.6";

  src = fetchFromGitLab {
    owner = "kalilinux/packages";
    repo = "oscanner";
    tag = "kali/1.0.6-1kali4";
    hash = "sha256-71tC1FYLWn12Re3Tl3GO6ZpSXiH08fRznu+g1RU0oq0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/oscanner $out/bin
    cp -r * $out/share/oscanner/

    makeWrapper ${jre}/bin/java $out/bin/oscanner \
      --run "cd $out/share/oscanner" \
      --add-flags "-cp .:ojdbc14.jar:java-getopt-1.0.9.jar:oscanner.jar:oracleplugins.jar:reportengine.jar ork.OracleScanner"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Oracle assessment framework";
    homepage = "https://gitlab.com/kalilinux/packages/oscanner";
    license = licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "oscanner";
  };
}
