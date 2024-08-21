{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
    environment.systemPackages = with pkgs; [
        binutils
        hping
        nmap
        one_gadget
        patchelf
        powershell
        pwndbg
        pwninit
        pwntools
        wireshark
        (python3.withPackages (python-pkgs: [
            python-pkgs.angr
            python-pkgs.capstone
            python-pkgs.gmpy2
            python-pkgs.pwndbg
            python-pkgs.pwntools
            python-pkgs.pycryptodome
            python-pkgs.pyelftools
            python-pkgs.ropgadget
            python-pkgs.z3-solver
        ]))
    ];
}
