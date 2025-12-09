{
  pkgs,
  ...
}:
{
  virtualisation.vmware.host.enable = true;

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    freerdp
    openssh
    rdesktop
    remmina # Remote desktop client
    tigervnc
    # keep-sorted end
  ];
}
