{pkgs, ...}: {
  services.flameshot = {
    enable = true;
    package = pkgs.flameshot.override {enableWlrSupport = true;}; # to enable Grim (Wayland) support
    # https://github.com/flameshot-org/flameshot/blob/master/flameshot.example.ini
    settings = {
      General = {
        useGrimAdapter = true; # use grim, needed for wayland
        disabledGrimWarning = true; # disable warning about using grim
      };
    };
  };
}
