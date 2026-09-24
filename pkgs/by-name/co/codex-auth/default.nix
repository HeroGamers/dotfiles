{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_16,
  curl,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "codex-auth";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Loongphy";
    repo = "codex-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TrJtVP4gRdupx6StKWc2PIXoVnnlFMUqFw6JtEmWqZ4=";
  };

  # Two upstream non-TTY remove integration tests fail in the Nix build sandbox.
  postPatch = ''
    substituteInPlace tests/cli_integration_test.zig \
      --replace-fail 'test "Scenario: Given non-tty remove with invalid selection input when running remove then it fails without deleting accounts" {' 'fn skippedNonTtyRemoveInvalid() !void {' \
      --replace-fail 'test "Scenario: Given non-tty stdin when running interactive remove then it falls back to the numbered selector" {' 'fn skippedNonTtyRemoveFallback() !void {'
  '';

  nativeBuildInputs = [
    zig_0_16
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache"
    zig build -Doptimize=ReleaseSafe --prefix "$out"
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    zig build test
    runHook postCheck
  '';

  dontInstall = true;

  postFixup = ''
    wrapProgram "$out/bin/codex-auth" \
      --prefix PATH : ${lib.makeBinPath [ curl ]}
  '';

  meta = {
    description = "CLI tool for switching and managing Codex accounts";
    homepage = "https://github.com/Loongphy/codex-auth";
    license = lib.licenses.mit;
    mainProgram = "codex-auth";
    platforms = lib.platforms.linux;
  };
})
