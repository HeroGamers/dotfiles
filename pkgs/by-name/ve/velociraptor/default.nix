{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  mage,
  nodejs,
  writableTmpDirAsHomeHook,
}:
let
  version = "0.76";

  src = fetchFromGitHub {
    owner = "Velocidex";
    repo = "velociraptor";
    tag = "v${version}";
    sha256 = "sha256-sFQJHQBctv/1STB3HUSa510CyvYh3vsDbEKDqdQpxtc=";
  };

  guiAssets = buildNpmPackage {
    pname = "velociraptor-gui-assets";
    inherit version src;
    sourceRoot = "${src.name}/gui/velociraptor";
    npmDepsHash = "sha256-f9cRf9JP/GWd0nsFoWOzkakzMSmegjKKzalpBIePXx8=";
    npmBuildScript = "build";

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -r build "$out/build"
      runHook postInstall
    '';
  };
in
buildGoModule {
  pname = "velociraptor";
  inherit version src;

  vendorHash = "sha256-10EaPNY/7a9CCKKN2OKF+k7oj0DtPksW7LmY2nH8rC8=";

  doCheck = false;

  nativeBuildInputs = [
    mage
    nodejs
    writableTmpDirAsHomeHook
  ];

  env.CGO_CFLAGS = "-std=gnu11";

  buildPhase = ''
    runHook preBuild

    # Build GUI assets in a separate npm derivation and inject them before mage.
    rm -rf gui/velociraptor/build
    cp -r ${guiAssets}/build gui/velociraptor/build

    mage linux

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    bin_path="$(find output -maxdepth 1 -type f -name 'velociraptor-*' | head -n 1)"
    if [ -z "$bin_path" ]; then
      echo "No velociraptor binary found in output/"
      exit 1
    fi

    install -Dm755 "$bin_path" "$out/bin/velociraptor"

    runHook postInstall
  '';

  # ldflags = [
  #   "-w"
  #   "-s"
  #   # https://github.com/Velocidex/velociraptor/blob/master/magefile.go#L559
  #   "-X=www.velocidex.com/golang/velociraptor/config.commit_hash="
  #   "-X=www.velocidex.com/golang/velociraptor/config.build_time=1970-01-01T00:00:00Z"
  # ];

  # tags = [
  #   "server_vql"
  #   "extras"
  #   "release"
  #   "yara"
  # ];

  meta = with lib; {
    description = "A tool for collecting host based state information using The Velociraptor Query Language (VQL) queries";
    mainProgram = "velociraptor";
    homepage = "https://github.com/Velocidex/velociraptor";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.hero ];
    platforms = platforms.linux;
  };
}
