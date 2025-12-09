# Settings mostly follow https://github.com/NixOS/nixpkgs/blob/master/ci/default.nix
# Current commit: 1f2908105588cfccdd38136127e06af0400ad657

{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";

  # Be a bit more verbose by default, so we can see progress happening
  settings.verbose = 1;

  programs.actionlint.enable = true;

  programs.biome = {
    enable = true;
    # Disable settings validation because its inputs are liable to hash mismatch
    validate.enable = false;
    settings.formatter = {
      useEditorconfig = true;
    };
    settings.javascript.formatter = {
      quoteStyle = "single";
      semicolons = "asNeeded";
    };
    settings.json.formatter.enabled = false;
  };
  settings.formatter.biome.excludes = [
    "*.min.js"
    "pkgs/*"
  ];

  programs.keep-sorted.enable = true;

  # This uses nixfmt underneath, the default formatter for Nix code.
  # See https://github.com/NixOS/nixfmt
  programs.nixfmt = {
    enable = true;
    package = pkgs.nixfmt;
  };

  programs.yamlfmt = {
    enable = true;
    settings.formatter = {
      retain_line_breaks = true;
    };
  };

  programs.nixf-diagnose.enable = true;
  settings.formatter.nixf-diagnose = {
    # Ensure nixfmt cleans up after nixf-diagnose.
    priority = -1;
    options = [
      "--auto-fix"
      # Rule names can currently be looked up here:
      # https://github.com/nix-community/nixd/blob/main/libnixf/src/Basic/diagnostic.py
      # TODO: Remove the following and fix things.
      "--ignore=sema-unused-def-lambda-noarg-formal"
      "--ignore=sema-unused-def-lambda-witharg-arg"
      "--ignore=sema-unused-def-lambda-witharg-formal"
      "--ignore=sema-unused-def-let"
      # Keep this rule, because we have `lib.or`.
      "--ignore=or-identifier"
    ];
    excludes = [ ];
  };

  settings.formatter.editorconfig-checker = {
    command = "${pkgs.lib.getExe pkgs.editorconfig-checker}";
    options = [
      "-disable-indent-size"
      # TODO: Remove this once this upstream issue is fixed:
      #   https://github.com/editorconfig-checker/editorconfig-checker/issues/505
      "-disable-charset"
    ];
    includes = [ "*" ];
    priority = 1;
  };

  # TODO: Wait for this to be upstreamed into treefmt-nix:
  # https://github.com/numtide/treefmt-nix/issues/387
  settings.formatter.markdown-code-runner = {
    command = pkgs.lib.getExe pkgs.markdown-code-runner;
    options =
      let
        config = pkgs.writers.writeTOML "markdown-code-runner-config" {
          presets.nixfmt = {
            language = "nix";
            command = [ (pkgs.lib.getExe pkgs.nixfmt) ];
          };
        };
      in
      [ "--config=${config}" ];
    includes = [ "*.md" ];
  };

  programs.zizmor.enable = true;
}
