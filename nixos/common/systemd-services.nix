{
  pkgs,
  ...
}: {
    # System-level services
    # systemd.services.powerprofile = {
    #     enable = true;

    #     wantedBy = [ "multi-user.target" ];
    #     path = [ pkgs.coreutils ];
    #     serviceConfig = {
    #         User = "root";
    #         Group = "root";
    #     };

    #     script = ''
    #         echo "power" | tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
    #     '';
    # };

    # Graphical session services
    systemd.services.initScript = {
        enable = true;

        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];

        # wl-paste is a "hack" for stopping the touchpad from pasting when using it
        script = ''
            wl-paste -p --watch wl-copy -p '''
        '';
    };
}
