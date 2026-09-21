# dotfiles [nix edition]

Configuration files

## Development

Enter the repository environment with `nix develop` (or allow the included
nix-direnv configuration), then run `just --list` to see the available workflows.
Entering the environment installs a pre-commit hook backed by the same treefmt
configuration as `nix fmt`.
`just check-format` and `just check` provide the fast pre-commit validation
path; use `just check-host <host>` after changing a NixOS configuration.

GitHub Actions runs the same checks and evaluates every supported system. Add
a read-only deploy key for the private `HeroGamers/hackpkgs` repository as the
`HACKPKGS_SSH_KEY` repository secret to enable full evaluation. Pull requests
run only checks that do not require the private input; full evaluation runs on
pushes to `nix` so the deploy key is never exposed to pull request code.

Coding agents should start with [AGENTS.md](AGENTS.md). Tool-specific instruction
files only delegate to that canonical guidance.
