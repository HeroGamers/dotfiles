# dotfiles [nix edition]

Configuration files

## Development

Enter the repository environment with `nix develop` (or allow the included
nix-direnv configuration), then run `just --list` to see the available workflows.
Entering the environment installs a pre-commit hook backed by the same treefmt
configuration as `nix fmt`.
`just check-format` and `just check` provide the fast pre-commit validation
path; use `just check-host <host>` after changing a NixOS configuration.

GitHub Actions runs the formatting and static checks on pull requests and
pushes to `nix`. Host evaluation remains a targeted local check with
`just check-host <host>` so routine CI stays fast and does not need access to
private inputs.

Coding agents should start with [AGENTS.md](AGENTS.md). Tool-specific instruction
files only delegate to that canonical guidance.
