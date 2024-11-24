{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (python3.withPackages (python-pkgs: [
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

      # Security
      #python-pkgs.angr # currently broken on nixpkgs
      python-pkgs.capstone
      python-pkgs.gmpy2
      python-pkgs.mitmproxy
      python-pkgs.pwndbg
      python-pkgs.pwntools
      python-pkgs.pycryptodome
      python-pkgs.pyelftools
      python-pkgs.ropgadget
      python-pkgs.z3-solver
    ]))
  ];
}
