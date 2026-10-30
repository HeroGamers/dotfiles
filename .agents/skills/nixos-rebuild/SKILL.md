---
name: nixos-rebuild
description: Build, deploy, and verify an existing NixOS flake configuration, or perform a requested rollback. Use for rebuild and activation tasks; input updates belong to flake-update and failure diagnosis to fix-nix.
---

# NixOS Rebuild

Read `AGENTS.md` for repository rules and `justfile` for checks. This skill handles
deployment of the requested configuration; it does not refresh dependencies.

## Identify the target and action

Inspect the worktree, flake outputs, target host entry point, and imports. For a
local deployment, compare the running hostname with the intended configuration.
Do not infer a remote target merely because a host is exported by the flake.
Clarify the target only when the request and environment leave it ambiguous.

Use the requested action and consult installed `nixos-rebuild --help` when needed:

| Action | Effect |
| --- | --- |
| Build | Builds a system closure without activating it. |
| Switch | Activates the configuration and makes it the boot default. |
| Boot | Sets the next boot configuration without activating it now. |
| Test | Activates temporarily without changing the boot default. |
| Rollback | Returns to an existing generation, as explicitly requested. |

Build and evaluation are safe defaults for a vague rebuild request. Switch,
boot, test, remote deployment, and rollback need authorization for that action
and target. An explicit request already given remains sufficient after fixes;
do not add another permission step merely because activation changes services.
Do not infer permission to reboot, delete generations, or perform cleanup.

## Validate and deploy the final configuration

Keep lockfiles and unrelated changes intact. Follow the checks in `AGENTS.md`
for any edits. Evaluate the target even when there are no edits. To build its
closure without a result link:

```sh
nix build .#nixosConfigurations.<host>.config.system.build.toplevel --no-link --no-update-lock-file --print-out-paths
```

Use the sibling `fix-nix` skill for failures when available, otherwise inspect
the underlying error and pinned definitions before repairing within scope.
Finish edits and validation before activating. Reuse evidence when another skill
already validated the same final worktree.

Before activation, record the current system path and existing failed units to
distinguish new failures. Preserve any explicitly selected specialisation. For
a requested local switch, use the equivalent of:

```sh
sudo nixos-rebuild switch --flake .#<host> --no-update-lock-file
```

Use configured caches when appropriate. Do not add upgrade or input-update flags.
For an authorized remote deployment, check the requested build and target hosts,
platform, and connection requirements rather than applying the local command.

## Verify activation or rollback

Check the command's exit status, `/run/current-system`, failed system units, and
services affected by the change, including integrated Home Manager. For boot-only
deployment, verify the selected boot generation; the running system should remain
on its current closure. Build success alone does not prove activation or health.

If activation fails, determine whether the system partially switched before
retrying or editing. Inspect targeted status and logs without exposing secrets.
Do not silently roll back. For a requested rollback, inspect available generations,
select the intended one, preserve newer generations, and verify the resulting
system and services. Explain any data migration a generation rollback cannot undo.

Report the target, action, resulting system path or generation, validation and
service health, and any pending reboot or activation. Inspect the final diff and
status when edits were made; commit only when requested.
