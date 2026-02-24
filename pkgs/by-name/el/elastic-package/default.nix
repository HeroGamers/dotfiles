{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:
let
  commitHash = "9762023";
in
buildGoModule rec {
  pname = "elastic-package";
  version = "0.120.0";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "elastic-package";
    tag = "v${version}";
    sha256 = "sha256-z923WIs3ibS72bJTlrc7w1GHDcG5S/v+Xow7GYPUQiE=";
  };

  vendorHash = "sha256-tIjTvd2FCxYUYy1j3pJQ6zA6MpwPdaTu/KsLTgJMIMQ=";

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
