{
    inputs,
    pkgs,
    lib,
    ...
}: {
    imports = [
        ./settings.nix
        ./binds.nix
        ./waybar
    ];

    wayland.windowManager.hyprland = {
        enable = true;

        # Use the hyprland from the flake
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

        # Extra configuration lines to add to ~/.config/hypr/hyprland.conf.
        # extraConfig = ''

        # '';

        systemd = {
            # Enables hyprland-session.target on startup
            enable = true;

            # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
            variables = ["--all"];

            # First two lines from https://github.com/nix-community/home-manager/blob/e1391fb22e18a36f57e6999c7a9f966dc80ac073/modules/services/window-managers/hyprland.nix#L99-L102
            extraCommands = [
                "systemctl --user stop graphical-session.target"
                "systemctl --user start hyprland-session.target"
            ];
        };

        # Enable xwayland (default true tho)
        xwayland.enable = true;

        # https://wiki.hyprland.org/Nix/Plugins/
        # From nixpkgs:
        # pkgs.hyprlandPlugins.<plugin>
        # From Flake:
        # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.<plugin>
        plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
            hyprbars
            hyprexpo
            #hyprlock
        ];
    };

    programs = {
        waybar = {
            enable = true;
        };
        wlogout = {
            enable = true;
        };
        # hyprlock = {
        #     enable = true;
        # };
    };

    # Enable gtk
    #gtk.enable = true;
}
