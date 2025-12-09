{
  inputs,
  pkgs,
  ...
}:
{
  virtualisation.vmware.host.enable = true;

  environment.systemPackages = with pkgs; [
    freerdp
    rdesktop
    remmina # Remote desktop client
    openssh
    tigervnc
  ];
}
