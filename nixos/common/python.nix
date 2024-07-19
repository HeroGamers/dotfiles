{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
    
    environment.systemPackages = with pkgs; [
        (python3.withPackages (python-pkgs: [
            python-pkgs.pandas
            python-pkgs.requests
            python-pkgs.numpy
            python-pkgs.scipy
            python-pkgs.sympy
            python-pkgs.pillow
            python-pkgs.aiohttp
            python-pkgs.beautifulsoup4
            python-pkgs.capstone
            python-pkgs.angr
            python-pkgs.pycryptodome
            python-pkgs.pyelftools
            python-pkgs.ropgadget
            python-pkgs.gmpy2
            python-pkgs.z3-solver
            python-pkgs.pwndbg
            python-pkgs.pwntools
        ]))
    ];
}