---
name: nix-package-maintenance
description: Update or repair custom Nix package derivations, including source and dependency hashes, patches, build helpers, installed outputs, and targeted validation. Use for package maintenance; use flake-update for flake input updates.
---

# Nix Package Maintenance

Read `AGENTS.md` and use `justfile` for repository checks. This workflow owns
package maintenance; use the sibling `fix-nix` skill for detailed diagnosis and
documentation lookup when needed.

## Locate the package and establish scope

Inspect the worktree, the package under `pkgs/by-name/`, its export in
`pkgs/default.nix`, and relevant overlays and consumers. Follow the actual
directory layout and builder rather than assuming a filename or language.
Inspect host entry points before changing shared modules.

Distinguish a version update, packaging repair, and a new package. For repairs,
retain the current upstream version unless a version change is needed and within
the request. A package update does not also update `flake.lock` or npins. If the
package comes from an input, determine whether the task belongs to `flake-update`
or needs a narrow override.

For upgrades, verify the target release or revision using upstream release notes
and source. Resolve an unspecified latest version from upstream rather than
memory. Note changes to supported platforms, configuration, licenses, or runtime
behavior that affect consumers.

## Update the derivation coherently

Check the pinned nixpkgs implementation and documentation for the build helper.
Keep the packaging approach unless a change is justified. Update the version,
source reference, and related embedded version or commit metadata together.
Review patches and substitutions against the new source; remove a patch only
when its purpose is obsolete or upstream contains the fix.

Handle each fixed-output hash according to what it covers:

- Source archives, repository snapshots, and release binaries can need different
  fetchers and hashes. Preserve options such as submodules and source roots.
- Dependency hashes such as `vendorHash`, `npmDepsHash`, and Cargo hashes cover
  separate outputs. Check upstream lockfile changes and regenerate the relevant
  output when needed; reusing an old hash can reuse stale dependencies.
- Verify the URL and revision before accepting a reported hash. Use the matching
  prefetch mechanism or a temporary fake hash and targeted build to obtain it.
  Remove temporary fake hashes before handing off.
- Preserve intentional values such as `vendorHash = null` when upstream vendors
  dependencies; do not replace them mechanically.

Keep builds reproducible and compatible with the Nix sandbox. Declare fetches
and build dependencies instead of allowing network access in build phases.
Review generated assets, wrappers, runtime library paths, installed binaries,
and completions where used. Investigate test failures rather than disabling
checks to pass an update; document necessary narrow exceptions. Respect whether
the build platform can execute the target binary.

## Validate the delivered package

Parse edited Nix files and run the checks required by `AGENTS.md`, including a
targeted build of the exported package:

```sh
nix build .#<package> --no-link --no-update-lock-file --print-out-paths
```

For a new package, confirm export and overlay integration. Git-backed flakes
omit untracked package files: make them visible to evaluation using an appropriate
staging or isolated-checkout approach without committing or including unrelated
work. Flake evaluation does not replace a package build.

Inspect the built output. When executable here, run a meaningful, non-mutating
smoke check such as its version or help command, or a small offline operation
relevant to the change. Avoid account changes, network services, and other side
effects; use temporary configuration when needed.

Evaluate affected hosts or packages and build a consumer when wrappers, linking,
or integration require it. Report unsupported platforms and unavailable checks.
Use `fix-nix` for failures and rebuild what is needed after repair.

Inspect the final diff and status. Report the package/version change, source
evidence, packaging changes, builds and smoke checks, and any runtime migration
or host activation needed. Installing, switching, and committing remain separate
actions requiring a request.
