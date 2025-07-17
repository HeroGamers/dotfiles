{ python2Packages, fetchFromGitHub }:

python2Packages.buildPythonApplication {
  pname = "peepdf-unstable";
  version = "20161117";

  src = fetchFromGitHub {
    owner = "jesparza";
    repo = "peepdf";
    rev = "c74dc65c0ac7e506bae4f2582a2435ec50741f40";
    sha256 = "05r7vpm57lq5nk99x9cmpkwy5yzqpqihs6ihy6nfms9nwynhl5aw";
  };

  format = "other";

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp -r . $out/lib
    ln -s $out/lib/peepdf.py $out/bin
  '';
}
