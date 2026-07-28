{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:
let
  commitHash = "111636a";
in
buildGoModule rec {
  pname = "elastic-package";
  version = "0.125.1";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "elastic-package";
    tag = "v${version}";
    sha256 = "sha256-T4gsIBSOGuSoNSQLpKgF7RAiipXM6zUad+gRY0DuP34=";
  };

  vendorHash = "sha256-w8NAaUUHgbP7GqrXQOLtRNhJB9TQG15IGfyvlHcbPSM=";

  ldflags = [
    "-s"
    "-w"
    # https://github.com/elastic/elastic-package/blob/main/Makefile
    # https://github.com/elastic/elastic-package/blob/main/.goreleaser.yml
    "-X=github.com/elastic/elastic-package/internal/version.CommitHash=${commitHash}"
    "-X=github.com/elastic/elastic-package/internal/version.BuildTime=0"
    "-X=github.com/elastic/elastic-package/internal/version.Tag=v${version}"
  ];

  doCheck = false;

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Mock the internal state so the binary bypasses its validation and network checks
    mkdir -p $HOME/.elastic-package/profiles/default
    echo "v${version}" > $HOME/.elastic-package/version
    echo "v${version}" > $HOME/.elastic-package/latestVersion

    installShellCompletion --cmd elastic-package \
      --bash <($out/bin/elastic-package completion bash) \
      --fish <($out/bin/elastic-package completion fish) \
      --zsh <($out/bin/elastic-package completion zsh)
  '';

  meta = with lib; {
    description = "Command line tool, written in Go, used for developing Elastic packages";
    mainProgram = "elastic-package";
    homepage = "https://github.com/elastic/elastic-package";
    license = licenses.unfree;
    maintainers = [ maintainers.hero ];
    platforms = platforms.linux;
  };
}
