{
  config,
  lib,
  pkgs,
  ...
}:
let
  bundle = "/run/worktop-ca/ca-certificates.crt";
  installBundle = pkgs.writeShellApplication {
    name = "install-worktop-ca";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      install -d -m 0755 /run/worktop-ca
      temporary=$(mktemp /run/worktop-ca/.ca-certificates.XXXXXX)
      trap 'rm -f "$temporary"' EXIT
      cat ${config.security.pki.caBundle} > "$temporary"
      printf '\n' >> "$temporary"
      cat ${config.sops.secrets.windows-ca.path} >> "$temporary"
      chmod 0644 "$temporary"
      mv -f "$temporary" ${bundle}
    '';
  };
in
{
  sops.secrets.windows-ca = {
    sopsFile = ../../secrets/worktop/windows-ca.json;
    format = "json";
    key = "ca_bundle";
    # Public trust anchors must be readable by unprivileged TLS clients.
    mode = "0444";
    restartUnits = lib.optional config.sops.useSystemdActivation "worktop-ca.service";
  };

  # Append only the SOC certificates from the Windows machine root store to
  # NixOS's public CA bundle at runtime, keeping their plaintext out of the store.
  environment.etc =
    lib.genAttrs
      [
        "ssl/certs/ca-certificates.crt"
        "ssl/certs/ca-bundle.crt"
        "pki/tls/certs/ca-bundle.crt"
      ]
      (_: {
        source = lib.mkForce bundle;
      });

  environment.variables = {
    NODE_EXTRA_CA_CERTS = config.sops.secrets.windows-ca.path;
    REQUESTS_CA_BUNDLE = bundle;
  };
  nix.settings.ssl-cert-file = bundle;

  system.build.worktopCaBundle = installBundle;

  system.activationScripts.worktopCa = lib.mkIf (!config.sops.useSystemdActivation) {
    deps = [ "setupSecrets" ];
    text = lib.getExe installBundle;
  };

  systemd.services.worktop-ca = lib.mkIf config.sops.useSystemdActivation {
    description = "Combine public CA certificates and SOC certificates";
    wantedBy = [ "sysinit.target" ];
    requiredBy = [ "sysinit-reactivation.target" ];
    requires = [ "sops-install-secrets.service" ];
    after = [ "sops-install-secrets.service" ];
    before = [
      "sysinit.target"
      "sysinit-reactivation.target"
      "shutdown.target"
    ];
    conflicts = [ "shutdown.target" ];
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = lib.getExe installBundle;
    };
  };
}
