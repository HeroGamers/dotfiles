{ ... }:
{
  # Inspired/yoinked a lot by https://github.com/fufexan/dotfiles
  wayland.windowManager.hyprland.settings = {
    # See https://wiki.hyprland.org/Configuring/Keywords/
    "$mod" = "SUPER"; # Sets "Windows" key as main modifier

    ################
    ### MONITORS ###
    ################

    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor = [
      # Catch-all
      ", preferred, auto, 1"
    ];
    source = [
      "~/.config/hypr/monitors.conf" # Use nwg-displays to manage monitors, saves config here
      "~/.config/hypr/workspaces.conf" # nwg-displays to manage default workspaces and binding workspaces to monitors, saves config here
    ];

    #################
    ### AUTOSTART ###
    #################

    # Autostart necessary processes (like notifications daemons, status bars, etc.)
    # Or execute your favorite apps at launch like this:

    # exec-once = $terminal
    # exec-once = nm-applet &
    # exec-once = waybar & firefox
    exec-once = [
      # system tray stuff
      "nm-applet" # network manager applet
      "blueman-applet" # bluetooth manager applet
      "trayscale --hide-window" # Tailscale tray icon
      #"systemctl --user start plasma-polkit-agent"
      #"${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"

      # dunst removed — DMS has a built-in notification daemon
      # "hypridle" # idle management — replaced by DMS built-in idle inhibitor
      # "waybar" # status bar - replaced with DMS
      "[workspace 1 silent] kitty" # terminal
      "[workspace 2 silent] firefox" # web browser
    ];

    #############################
    ### ENVIRONMENT VARIABLES ###
    #############################

    # env vars are NOT set here — using UWSM, which sources ~/.profile before Hyprland starts.
    # Set env vars in home.sessionVariables (home-manager/common/home.nix) instead.
    # https://wiki.hypr.land/Configuring/Environment-variables/

    #####################
    ### LOOK AND FEEL ###
    #####################

    # Refer to https://wiki.hyprland.org/Configuring/Variables/

    # https://wiki.hyprland.org/Configuring/Variables/#general
    general = {
      gaps_in = 1;
      gaps_out = 1;

      border_size = 2;

      # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
      "col.active_border" = "$pink $maroon 45deg";
      "col.inactive_border" = "$surface2";

      # Set to true enable resizing windows by clicking and dragging on borders and gaps
      resize_on_border = true;

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = false;

      layout = "dwindle";
    };

    # https://wiki.hyprland.org/Configuring/Variables/#decoration
    decoration = {
      rounding = 1;

      # Change transparency of focused and unfocused windows
      active_opacity = 1.0;
      inactive_opacity = 1.0;

      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        color = "$base";
        #ignore_window = true;
        #offset = "0 15";
        #scale = 0.97;
      };

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
    };

    # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
    # https://wiki.hypr.land/Configuring/Animations/#curves
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

    animation = [
      #"border, 1, 2, default"
      #"fade, 1, 4, default"
      #"windows, 1, 3, default, popin 80%"
      #"workspaces, 1, 2, default, slide"

      # Default config
      "windows, 1, 4, default, slide"
      "workspaces, 1,5, default, slide"
      #"windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      #"workspaces, 1, 6, default"
    ];

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
      disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
      disable_splash_rendering = true;

      # disable dragging animation
      #animate_mouse_windowdragging = false;

      # dpms
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;

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
        natural_scroll = true;
        #scroll_factor = 0.1;
      };
    };

    # gestures (touchscreen + workspace settings)
    # https://wiki.hyprland.org/Configuring/Variables/#gestures
    gestures = {
      # workspace_swipe_touch = true;  # this is a touchscreen not touchpad
      workspace_swipe_forever = true;
    };

    # touchpad gestures
    # gesture = fingers, direction, action, options
    # https://wiki.hypr.land/Configuring/Gestures/
    gesture = [
      # 3 finger gestures
      # Swipe 3 fingers horizontally to switch workspace
      "3, horizontal, workspace"
      # Swipe 3 fingers down to launch kitty
      "3, down, dispatcher, exec, kitty"
      # Swipe 3 fingers up to launch hyprexpo
      # "3, up, dispatcher, hyprexpo:expo, toggle"

      # 4 finger gestures
      "4, left, move, l"
      "4, right, move, r"
      "4, down, move, d"
      "4, up, move, u"

      # pinches
      "3, pinch, float"
      "4, pinch, fullscreen"
    ];

    ##############################
    ### WINDOWS AND WORKSPACES ###
    ##############################

    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

    # Japanese numeral names for workspaces (displayed by DMS workspace switcher)
    workspace = [
      "1, defaultName:一"
      "2, defaultName:二"
      "3, defaultName:三"
      "4, defaultName:四"
      "5, defaultName:五"
      "6, defaultName:六"
      "7, defaultName:七"
      "8, defaultName:八"
      "9, defaultName:九"
      "10, defaultName:十"
    ];

    windowrule = [
      "match:class .*, suppress_event maximize" # You'll probably like this. (what this do)
      # "match:float 0, hyprbars:no_bar on" # Hide bar on non-floating windows

      # https://wiki.hypr.land/Useful-Utilities/Screen-Sharing/#xwayland
      "match:class ^(xwaylandvideobridge)$, opacity 0.0 override"
      "match:class ^(xwaylandvideobridge)$, no_anim on"
      "match:class ^(xwaylandvideobridge)$, no_initial_focus on"
      "match:class ^(xwaylandvideobridge)$, max_size 1 1"
      "match:class ^(xwaylandvideobridge)$, no_blur on"
      "match:class ^(xwaylandvideobridge)$, no_focus on"

      # Kitty opacity
      "match:class kitty, opacity 0.8 0.8"

      # DMS - https://danklinux.com/docs/dankmaterialshell/compositors#window-rules-1
      "match:class ^(org.quickshell)$, float on"

      # Floating windows
      "match:class ^(gnome-calculator)$, float on"
      "match:class ^(blueman-manager)$, float on"
      "match:class ^(org\.gnome\.Nautilus)$, float on"

      # # Opacity for inactive windows
      # windowrulev2 = opacity 0.9 0.9, floating:0, focus:0

      # # GNOME apps
      # windowrulev2 = rounding 12, class:^(org\.gnome\.)
      # windowrulev2 = noborder, class:^(org\.gnome\.)

      # # Terminal apps - no borders
      # windowrulev2 = noborder, class:^(org\.wezfurlong\.wezterm)$
      # windowrulev2 = noborder, class:^(Alacritty)$
      # windowrulev2 = noborder, class:^(zen)$
      # windowrulev2 = noborder, class:^(com\.mitchellh\.ghostty)$
      # windowrulev2 = noborder, class:^(kitty)$

      # flameshot multi-display fix: https://ryanwise.me/blog/flameshot-on-hyprland/
      "match:class (flameshot), match:title (flameshot), move 0 0"
      "match:class (flameshot), match:title (flameshot), pin on"
      "match:class (flameshot), match:title (flameshot), fullscreen_state 0 0"
      "match:class (flameshot), match:title (flameshot), float on"
      "match:class (flameshot), match:title (flameshot), no_anim on" # disable animations for flameshot
    ];

    layerrule = [
      "match:namespace wofi, animation popin"
      "match:namespace waybar, animation slide"
      "match:namespace walker, animation popin"
      "match:namespace walker, dim_around on"
      # https://danklinux.com/docs/dankmaterialshell/compositors#layer-rules-1
      "match:namespace ^(dms)$, no_anim on" # no animations for DMS
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

    plugin = {
      # hyprbars = {
      #   bar_height = 20;
      #   bar_color = "rgb(363a4f)"; # catppuccin macchiato surface0
      #   col.text = "rgb(cad3f5)"; # catppuccin macchiato text
      #   bar_text_size = 10;
      #   bar_text_font = "Jetbrains Mono Nerd Font Mono Bold";
      #   bar_button_padding = 10;
      #   bar_padding = 10;
      #   bar_precedence_over_border = true;
      #   hyprbars-button = [
      #     "rgb(ed8796), 20, , hyprctl dispatch killactive" # catppuccin macchiato red
      #     "rgb(f5a97f), 20, , hyprctl dispatch fullscreen 2" # catppuccin macchiato peach
      #     "rgb(8aadf4), 20, , hyprctl dispatch togglefloating" # catppuccin macchiato blue
      #   ];
      # };

      # hyprexpo = {
      #   columns = 3;
      #   gap_size = 4;
      #   bg_col = "$crust";
      #   workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1

      #   gesture_distance = 300; # how far is the "max" for the gesture
      # };
    };
  };
}
