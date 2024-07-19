{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
    environment.systemPackages = with pkgs; [
        patchelf
        one_gadget
        pwninit
        pwntools
        pwndbg
        binutils
        hping
        nmap
        (python3.withPackages (python-pkgs: [
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