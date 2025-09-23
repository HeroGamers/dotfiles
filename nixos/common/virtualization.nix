{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  virtualisation.vmware.host.enable = true;

  environment.systemPackages = with pkgs; [
    # GNS3 Networking Simulator
    # gns3-gui
    # gns3-server # broken on current nixpkgs, has been fixed, waiting for flake update
    # Normal VM stuff
    qemu
    # virtualbox # not in cache, me no wanna compile it
    vmware-workstation
  ];
}
