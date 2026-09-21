# dotfiles [nix edition]

Configuration files

## Development

Enter the repository environment with `devenv shell` (or allow the included
direnv configuration), then run `just --list` to see the available workflows.
`just check-format` and `just check` provide the fast pre-commit validation
path; use `just check-host <host>` after changing a NixOS configuration.

Coding agents should start with [AGENTS.md](AGENTS.md). Tool-specific instruction
files only delegate to that canonical guidance.
