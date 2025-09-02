{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  virtualisation.vmware.host.enable = true;

  environment.systemPackages = with pkgs; [
    #freerdp
    freerdp3
    rdesktop
    remmina # Remote desktop client
    openssh
    tigervnc
  ];
}
