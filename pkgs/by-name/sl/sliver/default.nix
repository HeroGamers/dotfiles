{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  zip,
  installShellFiles,
}:
let
  # Yes, this is cursed - but we cannot use the networked asset generator which fetches the binaries :c
  goAssetsVersion = "1.25.6";
  zigAssetsVersion = "0.15.2";
  garbleAssetsVersion = "1.25.6";

  goDarwinAmd64 = fetchurl {
    url = "https://dl.google.com/go/go${goAssetsVersion}.darwin-amd64.tar.gz";
    sha256 = "1dvhjs0k52crk7070lmdpwcnw59z6swc82i8iqdr6qn2ylvv5dg2";
  };

  goDarwinArm64 = fetchurl {
    url = "https://dl.google.com/go/go${goAssetsVersion}.darwin-arm64.tar.gz";
    sha256 = "01m0jinz2chz39w9bgfhsgbl0619agcjvzc2sz3pflwajyp22icq";
  };

  goLinuxAmd64 = fetchurl {
    url = "https://dl.google.com/go/go${goAssetsVersion}.linux-amd64.tar.gz";
    sha256 = "06hqw1gvzfps0llmidx3dc6agiaqml4lvfdhm75jndlfsymbc8ph";
  };

  goLinuxArm64 = fetchurl {
    url = "https://dl.google.com/go/go${goAssetsVersion}.linux-arm64.tar.gz";
    sha256 = "1m9xjhbn2c49c24l7m3f165hnc5hnw137y6d9i174hn3g5yzi3kk";
  };

  goWindowsAmd64 = fetchurl {
    url = "https://dl.google.com/go/go${goAssetsVersion}.windows-amd64.zip";
    sha256 = "0dakmkyw0fayhjd1km63cj6jfz9nmkrqfqb5nl8wd9bvf8xp7d0r";
  };

  goWindowsArm64 = fetchurl {
    url = "https://dl.google.com/go/go${goAssetsVersion}.windows-arm64.zip";
    sha256 = "0q7viyi004446y23s9x4ck9697l0nz7kns71mp02x6l4s1nqwbcg";
  };

  zigDarwinAmd64 = fetchurl {
    url = "https://ziglang.org/download/${zigAssetsVersion}/zig-x86_64-macos-${zigAssetsVersion}.tar.xz";
    sha256 = "0zrzsjrj4gnx7zl4xcbk6gy6ni87yww9bny7q9px358lzh4njnrp";
  };

  zigDarwinArm64 = fetchurl {
    url = "https://ziglang.org/download/${zigAssetsVersion}/zig-aarch64-macos-${zigAssetsVersion}.tar.xz";
    sha256 = "0szswpn6d3j8j7fghggpv4l3qrdhn4q4n72h4zxwv1g1cyrvmhiw";
  };

  zigLinuxAmd64 = fetchurl {
    url = "https://ziglang.org/download/${zigAssetsVersion}/zig-x86_64-linux-${zigAssetsVersion}.tar.xz";
    sha256 = "0f9jz61fpjgc7bgfnl2hwm4ilgx68jn1s2wjnpjpd8ix307jgah2";
  };

  zigLinuxArm64 = fetchurl {
    url = "https://ziglang.org/download/${zigAssetsVersion}/zig-aarch64-linux-${zigAssetsVersion}.tar.xz";
    sha256 = "0zv6ix4jdzxh05mhrfnpnf0j54vspzpncxnjj1jsf3hdw38xg3lm";
  };

  zigWindowsAmd64 = fetchurl {
    url = "https://ziglang.org/download/${zigAssetsVersion}/zig-x86_64-windows-${zigAssetsVersion}.zip";
    sha256 = "036b2k6c7vfxnwgr2rbq4bw0cs9fyaghlag6lvi8qbwsg7ld23is";
  };

  zigWindowsArm64 = fetchurl {
    url = "https://ziglang.org/download/${zigAssetsVersion}/zig-aarch64-windows-${zigAssetsVersion}.zip";
    sha256 = "0w63dysi7jichxbqvgkgk5qb5clb4kndjz1548s9igvji1glc9mr";
  };

  garbleLinuxAmd64 = fetchurl {
    url = "https://github.com/moloch--/garble/releases/download/v${garbleAssetsVersion}/garble_linux-amd64";
    sha256 = "1ghlxwpyb0gd5b67cj5lwgy5jh3dp0m2cz85kdf643axqck5cxwv";
  };

  garbleLinuxArm64 = fetchurl {
    url = "https://github.com/moloch--/garble/releases/download/v${garbleAssetsVersion}/garble_linux-arm64";
    sha256 = "1cq3v6yw492rp4q5wyxw2jhkg7canw5h8sck7psih5hzfv766j0a";
  };

  garbleWindowsAmd64 = fetchurl {
    url = "https://github.com/moloch--/garble/releases/download/v${garbleAssetsVersion}/garble_windows-amd64.exe";
    sha256 = "1hx7kqqgsbzsifxl20n51r14yprxiyciy1ddg85nl19pnvy662x7";
  };

  garbleWindowsArm64 = fetchurl {
    url = "https://github.com/moloch--/garble/releases/download/v${garbleAssetsVersion}/garble_windows-arm64.exe";
    sha256 = "141qj314fl1h132da6vza4iy7nbxirv7976j7hggzgdx9b9r2nib";
  };

  garbleDarwinAmd64 = fetchurl {
    url = "https://github.com/moloch--/garble/releases/download/v${garbleAssetsVersion}/garble_darwin-amd64";
    sha256 = "0sqsp0h9iyga34p04c1rizl4rh17p60w4y65iiqaf70y405psqhg";
  };

  garbleDarwinArm64 = fetchurl {
    url = "https://github.com/moloch--/garble/releases/download/v${garbleAssetsVersion}/garble_darwin-arm64";
    sha256 = "0j4a9pb25qrjdsz85a3vsid0rdfnb6p349il2xrrqbl6w46bpan1";
  };
in
buildGoModule rec {
  pname = "sliver";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = "sliver";
    tag = "v${version}";
    sha256 = "sha256-3FYiDQiirc/VE9HEDny7/7x69XHQbylXPuKpcNJgLHw=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  subPackages = [
    "client"
    "server"
  ];

  tags = [
    "go_sqlite"
    "client"
    "server"
  ];

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
    # https://github.com/BishopFox/sliver/blob/master/Makefile
    "-X=github.com/bishopfox/sliver/client/command/update.SliverPublicKey=RWTZPg959v3b7tLG7VzKHRB1/QT+d3c71Uzetfa44qAoX5rH7mGoQTTR"
    "-X=github.com/bishopfox/sliver/client/assets.DefaultArmoryPublicKey=RWSBpxpRWDrD7Fe+VvRE3c2VEDC2NK80rlNCj+BX0gz44Xw07r6KQD9L"
    "-X=github.com/bishopfox/sliver/client/assets.DefaultArmoryRepoURL=https://api.github.com/repos/sliverarmory/armory/releases"
  ];

  preBuild = ''
    # Recreate server/assets/fs from pinned sources instead of running the networked generator.
    rm -rf server/assets/fs/{darwin,linux,windows}
    mkdir -p server/assets/fs/linux/amd64
    mkdir -p server/assets/fs/linux/arm64
    mkdir -p server/assets/fs/darwin/amd64
    mkdir -p server/assets/fs/darwin/arm64
    mkdir -p server/assets/fs/windows/amd64
    mkdir -p server/assets/fs/windows/arm64

    cp ${zigLinuxAmd64} server/assets/fs/linux/amd64/zig.tar.xz
    cp ${zigLinuxArm64} server/assets/fs/linux/arm64/zig.tar.xz
    cp ${zigDarwinAmd64} server/assets/fs/darwin/amd64/zig.tar.xz
    cp ${zigDarwinArm64} server/assets/fs/darwin/arm64/zig.tar.xz
    cp ${zigWindowsAmd64} server/assets/fs/windows/amd64/zig.zip
    cp ${zigWindowsArm64} server/assets/fs/windows/arm64/zig.zip

    cp ${garbleLinuxAmd64} server/assets/fs/linux/amd64/garble
    cp ${garbleLinuxArm64} server/assets/fs/linux/arm64/garble
    cp ${garbleDarwinAmd64} server/assets/fs/darwin/amd64/garble
    cp ${garbleDarwinArm64} server/assets/fs/darwin/arm64/garble
    cp ${garbleWindowsAmd64} server/assets/fs/windows/amd64/garble.exe
    cp ${garbleWindowsArm64} server/assets/fs/windows/arm64/garble.exe
    chmod +x server/assets/fs/linux/amd64/garble
    chmod +x server/assets/fs/linux/arm64/garble
    chmod +x server/assets/fs/darwin/amd64/garble
    chmod +x server/assets/fs/darwin/arm64/garble

    # Windows Go archives are already zip files in the expected layout.
    cp ${goWindowsAmd64} server/assets/fs/windows/amd64/go.zip
    cp ${goWindowsArm64} server/assets/fs/windows/arm64/go.zip

    # Convert tar.gz Go toolchains to go.zip layout expected by setupGo.
    mk_go_zip() {
      local src="$1"
      local out="$2"
      local tmp
      out="$(realpath -m "$out")"
      tmp="$(mktemp -d)"
      tar -xzf "$src" -C "$tmp"
      (
        cd "$tmp"
        zip -qr "$out" go
      )
      rm -rf "$tmp"
    }

    mk_go_zip ${goLinuxAmd64} server/assets/fs/linux/amd64/go.zip
    mk_go_zip ${goLinuxArm64} server/assets/fs/linux/arm64/go.zip
    mk_go_zip ${goDarwinAmd64} server/assets/fs/darwin/amd64/go.zip
    mk_go_zip ${goDarwinArm64} server/assets/fs/darwin/arm64/go.zip

    # src.zip is expected at fs/src.zip and gets unpacked into go/src at runtime.
    srcTmp="$(mktemp -d)"
    tar -xzf ${goLinuxAmd64} -C "$srcTmp"
    (
      cd "$srcTmp/go"
      zip -qr "$srcTmp/src.zip" src
    )
    mv "$srcTmp/src.zip" server/assets/fs/src.zip
    rm -rf "$srcTmp"
  '';

  # This will prefix all the binaries with sliver-
  postInstall = ''
    for f in $out/bin/*; do
      mv "$f" "$(dirname "$f")/sliver-$(basename "$f")"
    done
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sliver-client \
      --bash <($out/bin/sliver-client completion bash) \
      --fish <($out/bin/sliver-client completion fish) \
      --zsh <($out/bin/sliver-client completion zsh)
    installShellCompletion --cmd sliver-server \
      --bash <($out/bin/sliver-server completion bash) \
      --fish <($out/bin/sliver-server completion fish) \
      --zsh <($out/bin/sliver-server completion zsh)
  '';

  doCheck = false;

  nativeBuildInputs = [
    zip
    installShellFiles
  ];

  meta = with lib; {
    description = "An open source cross-platform adversary emulation/red team framework";
    mainProgram = "sliver";
    homepage = "https://sliver.sh";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.hero ];
    platforms = platforms.linux;
  };
}
