{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start

    uv

    # keep-sorted end

    # Python does NOT like having packages defined in multiple places
    (python3.withPackages (python-pkgs: [
      # keep-sorted start

      python-pkgs.aiofiles
      python-pkgs.aiohttp
      python-pkgs.beautifulsoup4
      python-pkgs.black
      python-pkgs.fastapi
      python-pkgs.flake8
      python-pkgs.jinja2
      python-pkgs.matplotlib
      python-pkgs.numpy
      python-pkgs.pandas
      python-pkgs.pillow
      python-pkgs.pyaudio
      python-pkgs.pydantic
      python-pkgs.requests
      python-pkgs.scipy
      python-pkgs.sympy
      python-pkgs.tkinter
      python-pkgs.uvicorn

      # keep-sorted end

      # Security
      # keep-sorted start

      # python-pkgs.angr # TODO: fix broken - https://github.com/NixOS/nixpkgs/issues/501379
      python-pkgs.capstone
      python-pkgs.gmpy2
      python-pkgs.mitmproxy
      # python-pkgs.pwndbg # removed
      python-pkgs.pwntools
      python-pkgs.pycryptodome
      python-pkgs.pyelftools
      python-pkgs.ropgadget
      python-pkgs.ropper
      python-pkgs.z3-solver

      # keep-sorted end
    ]))
  ];
}
