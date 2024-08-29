{
    pkgs,
    config, 
    ...
}:
{
  # Inspired/yoinked a lot by https://github.com/fufexan/dotfiles
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    # env = [
    #   "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    # ];

    exec-once = [
      "hyprlock"
      "waybar"
      "dunst"
      "systemctl --user start plasma-polkit-agent"
      #"${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
    ];

    # general = {
    #   gaps_in = 5;
    #   gaps_out = 5;
    #   border_size = 1;
    #   "col.active_border" = "rgba(88888888)";
    #   "col.inactive_border" = "rgba(00000088)";

    #   allow_tearing = true;
    #   resize_on_border = true;
    # };

    # decoration = {
    #   rounding = 16;
    #   blur = {
    #     enabled = true;
    #     brightness = 1.0;
    #     contrast = 1.0;
    #     noise = 0.01;

    #     vibrancy = 0.2;
    #     vibrancy_darkness = 0.5;

    #     passes = 4;
    #     size = 7;

    #     popups = true;
    #     popups_ignorealpha = 0.2;
    #   };

    #   drop_shadow = true;
    #   shadow_ignore_window = true;
    #   shadow_offset = "0 15";
    #   shadow_range = 100;
    #   shadow_render_power = 2;
    #   shadow_scale = 0.97;
    #   "col.shadow" = "rgba(00000055)";
    # };

    # animations = {
    #   enabled = true;
    #   animation = [
    #     "border, 1, 2, default"
    #     "fade, 1, 4, default"
    #     "windows, 1, 3, default, popin 80%"
    #     "workspaces, 1, 2, default, slide"
    #   ];
    # };

    # group = {
    #   groupbar = {
    #     font_size = 10;
    #     gradients = false;
    #     #text_color = "rgb(${c.primary})";
    #   };
    # };

    input = {
      kb_layout = "dk";

    #   # focus change on cursor move
    #   follow_mouse = 1;
    #   accel_profile = "flat";
    #   touchpad.scroll_factor = 0.1;
    };

    # dwindle = {
    #   # keep floating dimentions while tiling
    #   pseudotile = true;
    #   preserve_split = true;
    # };

    # misc = {
    #   # disable auto polling for config file changes
    #   disable_autoreload = true;

    #   force_default_wallpaper = 0;

    #   # disable dragging animation
    #   animate_mouse_windowdragging = false;

    #   # enable variable refresh rate (effective depending on hardware)
    #   vrr = 1;
    # };

    # render.direct_scanout = true;

    # # touchpad gestures
    # gestures = {
    #   workspace_swipe = true;
    #   workspace_swipe_forever = true;
    # };

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
