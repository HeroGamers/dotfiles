{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  # Enable cache for the pwndbg flake
  nix.settings = {
    substituters = ["https://pwndbg.cachix.org"];
    trusted-public-keys = ["pwndbg.cachix.org-1:HhtIpP7j73SnuzLgobqqa8LVTng5Qi36sQtNt79cD3k="];
  };

  environment.systemPackages = with pkgs; [
    aircrack-ng
    apktool
    arsenal
    autopsy
    binutils
    binwalk
    bloodhound
    burpsuite
    ffuf
    firewalk
    foremost
    gdb
    ghidra
    hashcat
    hping
    ida-pro
    iodine
    john
    metasploit
    mimikatz
    mitmproxy
    # mstrings
    netexec
    net-snmp
    nmap
    one_gadget
    patchelf
    powershell
    proxmark3
    pwndbg # TODO: fix gdbserver in pwntools to work with pwndbg
    pwninit
    pwntools
    samba
    sherlock
    sleuthkit
    sqlmap
    steghide
    tcpdump
    thc-hydra
    wireshark
    wordlists
    wpscan
    wstunnel
  ];

  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  # Prevent GC of IDA Pro
  # system.extraDependencies = [
  #   ida-pro.src
  # ];
}
