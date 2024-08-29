{
    config, 
    ...
}:
{
  wayland.windowManager.hyprland.settings = {
    bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mod, Q, exec, kitty"
        "$mod, F, exec, firefox"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, dolphin"
        "$mod, V, togglefloating,"
        "$mod, R, exec, wofi --show drun"
        "$mod, P, pseudo," # dwindle
        "$mod, J, togglesplit," # dwindle

        # lock screen
        #"$mod, L, exec, pgrep hyprlock || hyprlock"

        # Move focus with mod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        #", Print, exec, grimblast copy area"

        # Example special workspace (scratchpad)
        #"$mod, S, togglespecialworkspace, magic"
        #"$mod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
    ]
    # Switch workspaces with mod + [0-9]
    # Move active window to a workspace with mod + SHIFT + [0-9]
    ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
            ws = let
                c = (x + 1) / 10;
            in
                builtins.toString (x + 1 - (c * 10));
            in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
        )
        10)
    );

    # mouse movements
    bindm = [
        # Move/resize windows with mod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        #"$mod ALT, mouse:272, resizewindow"
    ];
  };
}
