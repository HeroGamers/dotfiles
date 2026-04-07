{
  lib,
  stdenv,
  fetchFromGitLab,
  perl,
}:

stdenv.mkDerivation {
  pname = "tnscmd10g";
  version = "1.3";

  src = fetchFromGitLab {
    owner = "kalilinux/packages";
    repo = "tnscmd10g";
    tag = "kali/1.3-1kali3";
    hash = "sha256-7svPIg/g9EFdDiPQZO13A2j0O8ekoL8hqQNkUQAflAM=";
  };

  buildInputs = [ perl ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp tnscmd10g $out/bin/tnscmd10g
    chmod +x $out/bin/tnscmd10g

    runHook postInstall
  '';

  meta = {
    description = "A simple perl script to ping the Oracle TNS listener";
    homepage = "https://gitlab.com/kalilinux/packages/tnscmd10g";
    maintainers = [ ];
    mainProgram = "tnscmd10g";
  };
}
