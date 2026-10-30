---
name: fix-nix
description: Diagnose and fix Nix evaluation, package build, NixOS, and Home Manager failures using pinned sources, version-matched documentation, and targeted upstream or community searches. Use for existing failures, including those exposed by input updates.
---

# Fix Nix

Read the repository's `AGENTS.md`. Follow its rules for module placement,
validation, secrets, and machine changes. This workflow diagnoses failures;
input-update scope and commit sequencing belong to the sibling `flake-update`
skill when that workflow is active.

## Reproduce and locate the cause

Inspect the worktree and establish the failing command, affected output or host,
and failure stage: parsing, evaluation, fetching, building, activation, or runtime.
Read the relevant entry point and imports, overlays, and package overrides.
Use the smallest command that reproduces the problem; avoid a live switch just
to reproduce an evaluation or build failure.

Read the underlying error rather than only the final dependent derivation failure.
For evaluation, request a trace when needed and inspect the named option and its
definitions. For a build, inspect the failed derivation's log, for example with
`nix log <derivation>`, before changing dependencies. For activation or runtime,
inspect relevant unit status and narrowly scoped logs without exposing secrets.

## Consult sources matching the configuration

Identify the installed Nix version and the actual pinned input revisions. Inspect
local pinned sources and evaluated option definitions first. This repository
follows unstable, but individual inputs or hosts may use different revisions.
Read the input graph rather than assuming every package comes from one nixpkgs.

For a flake input's local path, use metadata or a targeted expression such as:

```sh
nix eval --impure --raw --expr '(builtins.getFlake (toString ./.)).inputs.nixpkgs.outPath'
```

This expression uses impure evaluation only to locate the local flake. Do not
make impure evaluation a blanket workaround for a configuration error.

Use `rg` within the relevant input rather than searching the entire Nix store.
Useful source locations include nixpkgs `nixos/modules`, `pkgs/by-name`,
`pkgs/top-level/aliases.nix`, and `lib`, plus Home Manager `modules`. Inspect
option types, defaults, renames, assertions, and package metadata at the revision
actually used. An alias removal message is evidence for a migration, but not
proof that a replacement preserves the old behavior.

Consult the relevant documentation and lookup tools when pinned definitions do
not explain the issue, or migration and runtime behavior need clarification:

| Subject | Primary reference |
| --- | --- |
| Nix CLI, language, store, derivations | [Nix manuals](https://nix.dev/manual/nix/), selecting the installed version, and installed command help |
| Packages, overlays, build helpers | [Nixpkgs manual](https://nixos.org/manual/nixpkgs/unstable/) |
| NixOS modules and services | [NixOS manual](https://nixos.org/manual/nixos/unstable/) and [option search](https://search.nixos.org/options) |
| Nixpkgs library functions and signatures | [Noogle](https://noogle.dev/), then the pinned implementation |
| Home Manager modules and activation | [Home Manager manual](https://nix-community.github.io/home-manager/) and pinned module definitions |
| Other flake modules | That input's pinned source, official documentation, and release notes |

An unstable nixpkgs channel does not imply a development build of Nix itself.
Check `nix --version` for the executing CLI and the host's `config.nix.package`
when diagnosing a different target or a pending deployment. Prefer a versioned
manual such as `https://nix.dev/manual/nix/2.34/` for Nix 2.34.x; use the moving
stable alias only after checking that it matches. Development documentation,
including unstable links that redirect to Hydra, is relevant only when the actual
Nix build or feature requires it. Fall back to matching source and installed help
when those pages are unavailable.

Choose the appropriate channel in NixOS option search and follow source links.
Noogle helps discover functions and their signatures, but its indexed revision
may differ from this flake. Confirm option types and function behavior against
the actual pinned definitions. Apply the same version matching to Home Manager
and other inputs. Do not load every manual for each failure.

## Search for known failures

For unexplained errors, regressions, and migration details, search upstream issues,
pull requests, and community reports using the distinctive error fragment and
the affected package or option. Useful query shapes include:

- `site:github.com/NixOS/nixpkgs/issues "distinctive error fragment" package`
- `site:github.com/NixOS/nixpkgs/pull "distinctive error fragment" package`
- `site:discourse.nixos.org "distinctive error fragment"`

Use `NixOS/nix` for Nix CLI or store bugs and `nix-community/home-manager` for
Home Manager bugs when those are the relevant upstreams. Remove machine-specific
store hashes and sensitive details from search terms. If the exact phrase finds
nothing, shorten it and add the package, option, or version.

Read the actual issue or thread, including dates and follow-ups. Check whether a
proposed fix was merged and whether the pinned revision contains it. Treat forum
workarounds as diagnostic leads; verify them against source or official docs and
the local reproducer before applying. Cite the specific source supporting a
non-obvious fix and identify any remaining uncertainty.

## Repair the cause

Make the smallest declarative change that restores intended behavior. Preserve
option precedence and assess all consumers of a shared module. Distinguish a
rename from a replacement, removal, or data migration; explain material behavior
changes and ask when the user's intended outcome cannot be inferred.

Do not hide failures by broadly permitting broken or insecure packages, disabling
checks or features, changing state versions, or updating unrelated inputs. Treat
those as explicit tradeoffs only when necessary and within the user's request.

For hash mismatches, verify the intended source and revision before accepting a
new hash. For missing paths or cache problems, check the actual store path,
fetch/build requirements, and any import from derivation. Disabling the evaluation
cache is a targeted diagnostic only when evidence points there. Retry network
failures when useful; do not change modules to work around a temporary fetch
failure or assume a missing path proves store corruption. Avoid destructive
store/cache cleanup as a routine repair.

## Verify and report

Run the repository's required checks for the change, starting with the failing
command. Use syntax parsing for edited Nix files, evaluate affected consumers,
and build the relevant package or system when needed. After checks pass, avoid
repeating them without new edits or evidence. Report checks that remain blocked.

Activation, service restarts, and rollback require an explicit request. Existing
authorization in the current task remains valid; do not ask again merely because
fixes were needed. For an authorized activation, finish edits and validation first,
then verify the active configuration and relevant service health.

Inspect the final diff and status. Explain the root cause, change, evidence,
validation, remaining limits, and any action still needed on an affected host.
