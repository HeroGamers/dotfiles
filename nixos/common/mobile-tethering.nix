{ pkgs, ... }:
{
  services.usbmuxd = {
    enable = true;
    #package = pkgs.usbmuxd2;
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    ifuse # to mount with ifuse
    libimobiledevice
    # keep-sorted end
  ];
}
