{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom.security = {
    excludePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of package names to exclude from security packages";
    };
  };

  config = {
    # Enable cache for the pwndbg flake
    nix.settings = {
      substituters = [ "https://pwndbg.cachix.org" ];
      trusted-public-keys = [ "pwndbg.cachix.org-1:HhtIpP7j73SnuzLgobqqa8LVTng5Qi36sQtNt79cD3k=" ];
    };

    environment.systemPackages =
      lib.filter
        (pkg: !(builtins.elem (pkg.pname or pkg.name or "") config.custom.security.excludePackages))
        (
          with pkgs;
          [
            aircrack-ng
            apktool
            arsenal
            autopsy
            binaryninja-personal
            binutils
            binwalk
            bloodhound
            burpsuite
            capstone
            detect-it-easy # diE - Windows executable analysis tool
            ffuf
            firewalk
            foremost
            gdb
            ghidra
            hashcat
            hping
            ida-pro
            imhex
            iodine
            jadx # Dex to Java decompiler
            john
            metasploit
            mimikatz
            mitmproxy
            mstrings
            netexec
            net-snmp
            nmap
            one_gadget
            patchelf
            pdfminer
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
            zeek
            zeekscript
          ]
        );

    programs.wireshark = {
      enable = true;
      dumpcap.enable = true;
      usbmon.enable = true;
    };

    # Prevent GC of IDA Pro
    # system.extraDependencies = [
    #   ida-pro.src
    # ];
  };
}
