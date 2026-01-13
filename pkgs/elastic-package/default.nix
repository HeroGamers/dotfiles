{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:
let
  commitHash = "816ceec";
in
buildGoModule rec {
  pname = "elastic-package";
  version = "0.118.0";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "elastic-package";
    tag = "v${version}";
    sha256 = "sha256-QEkeMtuDhyeMQws7I8hUvB1YRU6EshtmfzU5ZnOPGjg=";
  };

  vendorHash = "sha256-B1G1EUYIXqf49HEXUv/nfaBnulJqi/ei3I9xOJ++T10=";

  ldflags = [
    "-s"
    "-w"
    # https://github.com/elastic/elastic-package/blob/main/Makefile#L8
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
