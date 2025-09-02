{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
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
    ghidra
    hashcat
    hping
    ida-pro
    iodine
    john
    metasploit
    mimikatz
    mitmproxy
    netexec
    net-snmp
    nmap
    one_gadget
    patchelf
    powershell
    pwndbg
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

  # Prevent GC of IDA Pro
  # system.extraDependencies = [
  #   ida-pro.src
  # ];
}
