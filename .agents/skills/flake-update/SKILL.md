---
name: flake-update
description: Update all or selected Nix flake inputs, or validate an update already made, then resolve compatibility failures and verify affected outputs.
---

# Flake Update

Read the repository's `AGENTS.md` and use its development environment and checks.
Let `justfile` define validation commands rather than copying them into this skill.

## Establish update scope

Inspect `git status`, `flake.nix`, and the relevant lockfile diff or recent update
commit. Preserve unrelated work and distinguish existing failures from regressions.

- For a full update, run `nix flake update`.
- For one input, run `nix flake update <input>`.
- For multiple named inputs, run `nix flake update <input1> <input2>`.
- If the user already updated inputs and requests fixes or evaluation, keep that
  lockfile and continue with validation; do not refresh it again.

Resolve input names against the actual flake graph. An input using `follows` may
require updating the input it follows; explain that mapping. Inspect the resulting
lockfile diff and keep changes limited to the requested inputs and dependencies
Nix must change with them. Do not also update npins or other dependency managers
unless requested. A request to fix an update does not authorize an unrelated
upgrade or rollback of inputs.

## Keep commits reviewable

When commits are requested, separate the dependency update from compatibility
fixes. Commit the lockfile update before making fixes when possible:

- Full update: `chore(nix): update flake lock`.
- Single input: `chore(nix): update <input>`.
- Several inputs: name the inputs or use the full-update title when clearer.

Use one or more subsequent fix commits grouped by meaningful behavior. Preserve
an existing update commit; do not amend it without a request. Stage only the
intended files or hunks and run normal hooks. If fixes already exist, separate
them using staging without discarding work or rewriting history. Without a
commit request, leave changes available for review and explain the proposed split.

## Evaluate and resolve failures

Discover outputs and affected hosts from `flake.nix` and imports rather than a
fixed host list. A broad nixpkgs or Home Manager update warrants evaluating all
consuming hosts; a narrow input update should cover its consumers. Include
standalone Home Manager outputs when affected, and distinguish them from NixOS
hosts and package outputs omitted by the current platform's flake check.

Run the repository checks. For each failure, use the sibling `fix-nix` skill when
available, or inspect the relevant pinned definitions, identify the underlying
cause, make a minimal fix, and rerun the failing check. Resolve configuration
errors separately from fetch, cache, sandbox, and build failures. Follow pinned
sources for renamed options and packages; assess behavior changes when a removed
component needs a replacement. Keep dependency revisions fixed while repairing
compatibility unless a dependency change is needed and within the user's scope.

Run formatting and the required host/package validation after edits. Evaluate
all consumers of a changed common module. Build changed packages or a relevant
system closure when evaluation does not exercise the changed behavior. A
successful evaluation is not evidence that a build or activation succeeded.

## Build, switch, and hand off

Identify the intended host before activation. Switch only when explicitly
requested; an existing request to update and switch is sufficient authorization
to continue after fixes. Once the final edits are validated, switch that final
configuration once. Do not switch an intermediate worktree while still editing.

After an authorized switch, verify `/run/current-system`, failed system units,
and relevant services, including Home Manager when integrated. Report the inputs
changed, compatibility fixes, checks and builds performed, activation result,
remaining warnings or blockers, and commit status. Call out hosts only evaluated
and behavior migrations needing real-host verification. Inspect the final diff
and status as required by `AGENTS.md`.
