{config, ...}: {
  wayland.windowManager.hyprland.settings = {
    bind =
      [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mod, Q, exec, kitty"
        "$mod, F, exec, firefox"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, dolphin"
        "$mod, V, togglefloating,"
        "$mod, R, exec, wofi --show drun" # launch wofi
        "$mod, space, exec, walker" # launch walker
        "$mod, P, pseudo," # dwindle
        "$mod, J, togglesplit," # dwindle

        # lock screen
        "$mod, L, exec, pgrep hyprlock || hyprlock"
        # CTRL + ALT + DEL for wlogout
        "CONTROL_ALT, Delete, exec, wlogout"

        # Move focus with mod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        # And with mod + HJKL
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        #", Print, exec, grimblast copy area"
        # ", Print, exec, grim -g \"$(slurp)\" - | wl-copy" # grim + slurp + wl-copy to clipboard
        ", Print, exec, XDG_CURRENT_DESKTOP=sway XDG_SESSION_DESKTOP=sway QT_QPA_PLATFORM=wayland flameshot gui" # flameshot gui, with wayland vars

        # Example special workspace (scratchpad)
        #"$mod, S, togglespecialworkspace, magic"
        #"$mod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Keyboard backlight - not needed on ThinkPad - the BIOS does it when pressing FN + Space
        # ", XF86MonBrightnessUp, exec, brightnessctl -d *::kbd_backlight set +33%"
        # ", XF86MonBrightnessDown, exec, brightnessctl -d *::kbd_backlight set 33%-"

        # Monitor backlight
        ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"

        # Volume and Media Control
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+" # To raise the volume, with a limit of 150%
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        # ", XF86AudioLowerVolume, exec, pamixer -d 5"
        # ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        # ", XF86AudioMicMute, exec, pamixer --default-source -m"
        # ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
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
