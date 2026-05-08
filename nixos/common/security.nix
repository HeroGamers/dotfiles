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
            # keep-sorted start
            aircrack-ng
            apktool
            arsenal
            autopsy # which fucking sucks on Linux btw.
            autorecon
            binaryninja-personal
            binutils
            binwalk
            binwalk2
            bloodhound
            bubblewrap
            burpsuite
            capstone
            chisel
            ctf-dl
            ctf-man
            detect-it-easy # diE - Windows executable analysis tool
            dirb
            dnsrecon
            enum4linux
            exploitdb
            feroxbuster
            ffuf
            # firewalk  # broken derivation: https://github.com/NixOS/nixpkgs/issues/481763
            foremost
            gdb
            ghidra
            gobuster
            hashcat
            hping
            ida-pro
            imhex
            iodine
            jadx # Dex to Java decompiler
            john
            ligolo-ng
            kerbrute
            metasploit
            nikto
            mimikatz
            mitmproxy
            mstrings
            nbtscan
            net-snmp
            netexec
            nmap
            nss
            onesixtyone
            one_gadget
            oscanner
            patchelf
            pdfminer
            powershell
            proxmark3
            proxychains-ng
            pwndbg # TODO: fix gdbserver in pwntools to work with pwndbg
            pwninit
            pwntools
            redis
            samba
            sherlock
            sipvicious
            sleuthkit
            smbmap
            sqlmap
            sslscan
            steghide
            tcpdump
            thc-hydra
            tnscmd10g
            whatweb
            wireshark
            wordlists
            wpscan
            wstunnel
            zeek
            zeekscript
            # keep-sorted end
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
