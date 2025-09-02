{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  virtualisation.vmware.host.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
    # virtualbox # not in cache, me no wanna compile it
    vmware-workstation
  ];
}
