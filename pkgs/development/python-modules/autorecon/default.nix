{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  seclists,
  curl,
  dnsrecon,
  enum4linux,
  feroxbuster,
  gobuster,
  # dirsearch,
  ffuf,
  dirb,
  impacket,
  nbtscan,
  nikto,
  nmap,
  onesixtyone,
  oscanner ? pkgs.callPackage ../../../by-name/os/oscanner { },
  samba,
  smbmap,
  net-snmp,
  sslscan,
  sipvicious,
  tnscmd10g ? pkgs.callPackage ../../../by-name/tn/tnscmd10g { },
  whatweb,
  unidecode,
  colorama,
  platformdirs,
  psutil,
  toml,
  requests,
}:
buildPythonPackage {
  pname = "autorecon";
  version = "2.0.36";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AutoRecon";
    repo = "AutoRecon";
    rev = "e7e98f60bdc5fb1695159c1bbcdfdf2746d30fa6";
    hash = "sha256-xSRfsfLRYt7jS5Jpp6fz5/Kj2DiNI3hgUbUI9w3AHkw=";
  };

  # Replace hardcoded seclists paths with the nix store path.
  postPatch = ''
    grep -rl "/usr/share/seclists" | xargs sed -i "s|/usr/share/seclists|${seclists}/share/wordlists/seclists|g" || true
  '';

  pythonRelaxDeps = [
    "impacket"
    "psutil"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    impacket
    unidecode
    colorama
    platformdirs
    psutil
    toml
    requests
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      seclists
      curl
      dnsrecon
      enum4linux
      feroxbuster
      gobuster
      # dirsearch # optional: dirbuster plugin supports it - TODO: wait for fix of dirsearch
      ffuf # optional: dirbuster plugin supports it
      dirb # optional: dirbuster plugin supports it
      impacket # impacket-scripts
      nbtscan
      nikto
      nmap
      onesixtyone
      oscanner
      pkgs.redis # redis-tools
      samba # smbclient
      smbmap
      net-snmp # snmpwalk
      sslscan
      sipvicious
      tnscmd10g
      whatweb
    ])
  ];

  pythonImportsCheck = [ "autorecon" ];

  meta = with lib; {
    homepage = "https://github.com/AutoRecon/AutoRecon";
    description = "A multi-threaded network reconnaissance tool which performs automated enumeration of services";
    mainProgram = "autorecon";
    maintainers = [ maintainers.hero ];
    license = licenses.gpl3Plus;
  };
}
