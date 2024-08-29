{
    pkgs,
    config,
    lib,
    ...
}:
{
  # Inspired/yoinked a lot by https://github.com/fufexan/dotfiles
  wayland.windowManager.hyprland.settings = lib.mkDefault {
    # See https://wiki.hyprland.org/Configuring/Keywords/
    "$mod" = "SUPER"; # Sets "Windows" key as main modifier

    ################
    ### MONITORS ###
    ################

    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor = ",preferred,auto,auto";

    #################
    ### AUTOSTART ###
    #################

    # Autostart necessary processes (like notifications daemons, status bars, etc.)
    # Or execute your favorite apps at launch like this:

    # exec-once = $terminal
    # exec-once = nm-applet &
    # exec-once = waybar & hyprpaper & firefox
    exec-once = [
      #"hyprlock"
      #"waybar"
      #"dunst"
      #"systemctl --user start plasma-polkit-agent"
      #"${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
    ];

    #############################
    ### ENVIRONMENT VARIABLES ###
    #############################

    # See https://wiki.hyprland.org/Configuring/Environment-variables/
    env = [
      #"QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
    ];

    #####################
    ### LOOK AND FEEL ###
    #####################

    # Refer to https://wiki.hyprland.org/Configuring/Variables/

    # https://wiki.hyprland.org/Configuring/Variables/#general
    general = {
      gaps_in = 5;
      gaps_out = 20;

      border_size = 2;

      # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";

      # Set to true enable resizing windows by clicking and dragging on borders and gaps
      resize_on_border = true;

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = false;

      layout = "dwindle";
    };

    # https://wiki.hyprland.org/Configuring/Variables/#decoration
    decoration = {
      rounding = 10;

      # Change transparency of focused and unfocused windows
      active_opacity = 1.0;
      inactive_opacity = 1.0;

      drop_shadow = true;
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
      #shadow_ignore_window = true;
      #shadow_offset = "0 15";
      #shadow_scale = 0.97;

      # https://wiki.hyprland.org/Configuring/Variables/#blur
      blur = {
        enabled = true;

        size = 3;
        passes = 1;

        #brightness = 1.0;
        #contrast = 1.0;
        #noise = 0.01;

        vibrancy = 0.1696;
        #vibrancy_darkness = 0.5;

        #popups = true;
        #popups_ignorealpha = 0.2;
      };
    };

    # https://wiki.hyprland.org/Configuring/Variables/#animations
    animations = {
      enabled = true;

      # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

      animation = [
        #"border, 1, 2, default"
        #"fade, 1, 4, default"
        #"windows, 1, 3, default, popin 80%"
        #"workspaces, 1, 2, default, slide"

        # Default config
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    dwindle = {
      # keep floating dimentions while tiling
      pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = true; # You probably want this
    };

    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    master = {
      new_status = "master";
    };

    # https://wiki.hyprland.org/Configuring/Variables/#misc
    misc = {
      # disable auto polling for config file changes
      #disable_autoreload = true;

      force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(

      # disable dragging animation
      #animate_mouse_windowdragging = false;

      # enable variable refresh rate (effective depending on hardware)
      #vrr = 1;
    };
    
    #############
    ### INPUT ###
    #############

    # https://wiki.hyprland.org/Configuring/Variables/#input
    input = {
      kb_layout = "dk";
      # kb_variant =
      # kb_model =
      # kb_options =
      # kb_rules =

      # focus change on cursor move
      follow_mouse = 1;

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      #accel_profile = "flat";

      touchpad = {
        natural_scroll = false;
        #scroll_factor = 0.1;
      };
    };

    # touchpad gestures
    # https://wiki.hyprland.org/Configuring/Variables/#gestures
    gestures = {
      workspace_swipe = true;
      workspace_swipe_forever = true;
    };

    ##############################
    ### WINDOWS AND WORKSPACES ###
    ##############################

    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

    # Example windowrule v1
    # windowrule = float, ^(kitty)$

    # Example windowrule v2
    # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

    windowrulev2 = [
      "suppressevent maximize, class:.*" # You'll probably like this.
    ];

    # group = {
    #   groupbar = {
    #     font_size = 10;
    #     gradients = false;
    #     #text_color = "rgb(${c.primary})";
    #   };
    # };

    # render.direct_scanout = true;

    # xwayland.force_zero_scaling = true;

    # debug.disable_logs = false;

    # plugin = {
    #   hyprbars = {
    #     bar_height = 20;
    #     bar_precedence_over_border = true;
    #   };

    #   hyprexpo = {
    #     columns = 3;
    #     gap_size = 4;
    #     bg_col = "rgb(000000)";

    #     enable_gesture = true;
    #     gesture_distance = 300;
    #     gesture_positive = false;
    #   };
    # };
  };
}
