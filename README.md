# dotfiles [nix edition]

Configuration files

Manual setup references:

- [Worktop local inference with llama.cpp and OMP](home-manager/worktop/local-inference/README.md)

## Development

Enter the repository environment with `nix develop` (or allow the included
nix-direnv configuration), then run `just --list` to see the available workflows.
Entering the environment installs a pre-commit hook backed by the same treefmt
configuration as `nix fmt`.
`just check-format` and `just check` provide the fast pre-commit validation
path; use `just check-host <host>` after changing a NixOS configuration.

`just check` uses writable evaluation so Nix can restore missing evaluation-time
dependencies, then runs the declared formatting and pre-commit checks. It does
not build host closures. Avoid adding `--no-build`: that makes evaluation
read-only and can cause invalid-store-path errors after garbage collection.

GitHub Actions runs the formatting and static checks on pull requests and
pushes to `nix`. Host evaluation remains a targeted local check with
`just check-host <host>` so routine CI stays fast and does not need access to
private inputs.

Coding agents should start with [AGENTS.md](AGENTS.md). Tool-specific instruction
files only delegate to that canonical guidance.
