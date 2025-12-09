{
  pkgs,
  ...
}:
{
  virtualisation.vmware.host.enable = true;

  environment.systemPackages = with pkgs; [
    # keep-sorted start

    # gns3-gui
    # gns3-server # GNS3 Networking Simulator
    qemu
    # virtualbox # not in cache, me no wanna compile it
    vmware-workstation

    # keep-sorted end
  ];
}
