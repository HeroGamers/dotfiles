{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:
buildGoModule rec {
  pname = "elastic-package";
  # 0.116.0+ requires Go 1.25.3, which I don't have in my nixpkgs yet
  version = "0.115.0";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "elastic-package";
    rev = "v${version}";
    # sha256 = "sha256-RHCtYmaxhSbiSccbID/dhBWJ9E5lSeo9DSfLz+5dYwA=";  # for 0.117.1
    sha256 = "sha256-+CMnhLT4h2/o956OpHxDuSl2DTmLCqM+awaSQW0k5w8=";
  };

  vendorHash = "sha256-yTHemK2ptLRkmbUgMGSmHa3O2bWgXNx8VBCwhmB9Q1A=";

  ldflags = [
    "-s"
    "-w"
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
    maintainers = with maintainers; [ herogamers ];
    platforms = platforms.linux;
  };
}
