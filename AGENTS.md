# Repository guidance for coding agents

## Scope

This file applies to the entire repository. It is the canonical instruction file
for coding agents; tool-specific files should include or point here instead of
copying these instructions.

## Repository map

- `flake.nix` defines flake inputs, development shells, formatter integration,
  custom packages, NixOS configurations, and standalone Home Manager outputs.
- `nixos/<host>/` contains host entry points and host-specific configuration.
- `nixos/common/` contains reusable NixOS modules. Prefer a common module when a
  setting is shared by more than one host.
- `home-manager/<host>/` contains per-host user configuration.
- `home-manager/common/` contains reusable Home Manager modules and dotfiles.
- `modules/` contains modules exported for consumers of this flake.
- `pkgs/by-name/` contains custom packages; `pkgs/default.nix` exposes them.
- `overlays/` contains the package overlays used by NixOS configurations.
- `secrets/` contains SOPS-encrypted data. Treat even encrypted secret files as
  sensitive and do not edit or decrypt them unless the task explicitly requires
  it.
- The default flake dev shell defines the contributor environment, while
  `treefmt.nix` is the formatting source of truth.

The NixOS configuration names are `ctf-vm`, `flareon`, `hacktop`,
`hero-desktop`, `oci-vps`, and `worktop`.

## Working agreement

1. Inspect the relevant host entry point and its imports before editing a common
   module. Keep host-specific behavior in the host directory.
2. Make the smallest declarative change that satisfies the task. Preserve
   existing option precedence (`mkDefault`, `mkForce`, and plain assignments).
3. Keep regions marked for `keep-sorted` sorted. Let the repository formatter
   handle layout instead of hand-formatting around them.
4. Do not update `flake.lock` or `npins/sources.json` unless the task is
   specifically about dependency updates.
5. Do not edit generated `.direnv`, `result`, or `result-*` paths.
6. Never print secret values or read material from `/run/secrets`. Do not run
   SOPS decryption in routine validation.
7. A live `nixos-rebuild switch`, Home Manager activation, service restart,
   network change, or destructive cleanup changes the user's machine. Only do
   one when the user explicitly requests it. Evaluation and builds are safe
   defaults.
8. Preserve unrelated work in a dirty worktree. Do not discard or rewrite user
   changes.

## Development environment

If direnv is available, run `direnv allow` once. Otherwise use `nix develop`.

Useful commands:

```sh
just --list
just fmt
just check-format
just check
just check-host hero-desktop
```

Use `nix build .#<package>` for a changed custom package. Building a host closure
is stronger validation when warranted:

```sh
nix build .#nixosConfigurations.<host>.config.system.build.toplevel
```

## Validation

Run checks in proportion to the change, and report checks that could not run.

- Documentation-only: `just check-format`. Treefmt applies fixes before failing,
  so inspect the resulting diff.
- Nix module or flake change: `just check-format`, `just check`, and
  `just check-host <affected-host>` for every affected host.
- Custom package change: the checks above plus `nix build .#<package>`.
- Cross-cutting common-module change: evaluate every host that imports it; use a
  full host build when evaluation alone would not exercise the behavior.

`just check` evaluates flake checks without building every output. It opts into
unfree evaluation because the flake exports `elastic-package`; it is not a
substitute for a targeted package or system build when derivation contents
changed.

## Review expectations

Before handing off work, inspect `git diff --check`, `git diff`, and
`git status --short`. Summarize the behavior changed, validation performed, and
any follow-up that still requires activation on a real host.
