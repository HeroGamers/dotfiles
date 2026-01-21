{ pkgs, ... }:
{
  programs = {
    # keep-sorted start
    vscode = {
      profiles.default.extensions =
        with pkgs.vscode-extensions;
        [
          # keep-sorted start
          bierner.markdown-preview-github-styles # GitHub Markdown styles
          bradlc.vscode-tailwindcss # Tailwind CSS support
          charliermarsh.ruff # Python linter
          davidanson.vscode-markdownlint # Markdown linting
          # syler.sass-indented # Sass support
          # sibiraj-s.vscode-scss-formatter # SCSS formatter
          dbaeumer.vscode-eslint # JavaScript/TypeScript linter
          esbenp.prettier-vscode # Prettier code formatter
          # adrieankhisbe.vscode-ndjson # NDJSON support
          formulahendry.code-runner
          gencer.html-slim-scss-css-class-completion # HTML & Slim & SCSS class completion
          github.copilot
          github.copilot-chat
          golang.go # Go LSP
          jebbs.plantuml # PlantUML support
          jnoortheen.nix-ide # Nix LSP
          mechatroner.rainbow-csv # CSV support
          ms-azuretools.vscode-containers # Container support
          ms-azuretools.vscode-docker # Docker support
          # astral-sh.ty # Python type checking, pylance alternative
          ms-python.debugpy # Python Debugger
          ms-python.python # Python LSP
          ms-python.vscode-pylance # Python LSP
          ms-vscode-remote.remote-ssh # Remote SSH
          ms-vscode.cmake-tools # CMake support
          ms-vscode.cpptools # C/C++ LSP
          # vscodevim.vim # Vim emulation
          ms-vscode.makefile-tools # Makefile support
          ms-vscode.powershell # PowerShell support
          myriad-dreamin.tinymist # Typst engine
          redhat.vscode-xml # XML support
          redhat.vscode-yaml # YAML support
          rust-lang.rust-analyzer # Rust LSP
          svelte.svelte-vscode # Svelte LSP
          tamasfe.even-better-toml # TOML support
          usernamehw.errorlens
          wakatime.vscode-wakatime # WakaTime integration
          wholroyd.jinja # Jinja support
          yzhang.markdown-all-in-one # Markdown support
          # keep-sorted end
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ ];
    };
    # keep-sorted end
  };
}
