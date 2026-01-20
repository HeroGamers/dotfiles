{
  pkgs,
  ...
}:
{
  programs = {
    # keep-sorted start
    vscode = {
      profiles.default.extensions =
        with pkgs.vscode-extensions;
        [
          # keep-sorted start
          jnoortheen.nix-ide # Nix LSP
          ms-python.python # Python LSP
          ms-python.vscode-pylance # Python LSP
          ms-python.debugpy # Python Debugger
          ms-vscode.cpptools # C/C++ LSP
          ms-vscode.cmake-tools # CMake support
          golang.go # Go LSP
          svelte.svelte-vscode # Svelte LSP
          myriad-dreamin.tinymist # Typst engine
          rust-lang.rust-analyzer # Rust LSP
          tamasfe.even-better-toml # TOML support
          redhat.vscode-yaml # YAML support
          yzhang.markdown-all-in-one # Markdown support
          bierner.markdown-preview-github-styles # GitHub Markdown styles
          davidanson.vscode-markdownlint # Markdown linting
          charliermarsh.ruff # Python linter
          # syler.sass-indented # Sass support
          # sibiraj-s.vscode-scss-formatter # SCSS formatter
          dbaeumer.vscode-eslint # JavaScript/TypeScript linter
          mechatroner.rainbow-csv # CSV support
          ms-vscode.powershell # PowerShell support
          gencer.html-slim-scss-css-class-completion # HTML & Slim & SCSS class completion
          wholroyd.jinja # Jinja support
          bradlc.vscode-tailwindcss # Tailwind CSS support
          redhat.vscode-xml # XML support
          ms-azuretools.vscode-docker # Docker support
          ms-azuretools.vscode-containers # Container support
          ms-vscode-remote.remote-ssh # Remote SSH
          wakatime.vscode-wakatime # WakaTime integration
          vscodevim.vim # Vim emulation
          # keep-sorted end
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ ];
    };
    # keep-sorted end
  };
}
