{...}: {
  # Inspired/yeeted from https://github.com/rubyowo/dotfiles/blob/nixos/users/rei/confs/waybar/style.css
  # and https://github.com/qoheniac/config/blob/main/waybar/style.css
  # and https://github.com/d00m1k/SimpleBlueColorWaybar/blob/main/style.css
  programs.waybar.style = ''
    * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", "Clear Sans", "Fira Sans Semibold", "Font Awesome 6 Free Solid", FontAwesome, Roboto, monospace;
        font-size: 12px;
        min-height: 0;
        transition: background-color .3s ease-out;
    }

    window#waybar {
        background: rgba(26, 27, 38, 0.75);
        color: @text;
        transition-property: background-color;
        transition-duration: .5s;
    }

    window#waybar.empty {
        color: rgba(0,0,0,0);
    }

    .topbar {
        border-bottom: 3px solid rgba(100, 114, 125, 1);
    }

    .bottombar {
        border-top: 3px solid rgba(100, 114, 125, 1);
    }

    #workspaces {
        border-radius: 1rem;
        background-color: @surface0;
        /*margin-top: 1rem;
        margin: 3px 3px 0px 3px;*/
    }

    #workspaces button {
        padding: 0 5px;
        background: transparent;
        background-color: transparent;
        color: @sapphire;

        font-weight: 900;
        font-size: 13pt;
        border:none;
        border-radius: 15px;
    }

    #workspaces button.active {
        color: @flamingo;
        background: #13131d;
    }

    #workspaces button.focused {
        background-color: #64727D;
        box-shadow: none;
    }

    #workspaces button.urgent {
        background-color: #eb4d4b;
    }

    #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
        box-shadow: none;
        color: @blue;
    }

    #backlight,
    #power-profiles-daemon,
    #battery,
    #battery.bat1,
    #battery.bat2,
    #clock,
    #cpu,
    #custom-mail,
    #custom-lock,
    #custom-power
    #custom-poweroff,
    #custom-weather,
    #disk,
    #idle_inhibitor,
    #memory,
    #mode,
    #network,
    #network.vpn,
    #network.wifi,
    #network.ethernet,
    #network.disconnected,
    #pulseaudio,
    #taskbar,
    #temperature,
    #tray,
    #wireplumber,
    #custom-media,
    #scratchpad,
    #language,
    #mpd {
        padding: 0 6px;
        margin: 0 0px;
        color: @text;
        border-radius: 15px;
        /*background-color: rgba(0, 0, 8, .7);*/
    }

    #backlight:hover,
    #power-profiles-daemon:hover,
    #battery:hover,
    #battery.bat1:hover,
    #battery.bat2:hover,
    #clock:hover,
    #cpu:hover,
    #custom-mail:hover,
    #custom-lock:hover,
    #custom-power
    #custom-poweroff:hover,
    #custom-weather:hover,
    #disk:hover,
    #idle_inhibitor:hover,
    #memory:hover,
    #mode:hover,
    #network:hover,
    #network.vpn:hover,
    #network.wifi:hover,
    #network.ethernet:hover,
    #network.disconnected:hover,
    #pulseaudio:hover,
    #taskbar:hover,
    #temperature:hover,
    #tray:hover,
    #wireplumber:hover,
    #custom-media:hover,
    #scratchpad:hover,
    #language:hover,
    #mpd:hover {
        background: rgba(26, 27, 38, 0.9);
    }

    .modules-left,
    .modules-center,
    .modules-right
    {
        background: @surface0;
        margin: 5px 10px;
        padding: 0 5px;
        border-radius: 15px;
    }
    .modules-left {
        padding: 0;
    }
    .modules-center {
        padding: 0 10px;
    }

    @keyframes blink {
        to {
            background-color: #ffffff;
            color: #000000;
        }
    }

    #mode {
        background-color: #64727D;
        border-top: 3px solid #ffffff;
    }

    #clock {
        color: @lavender;
    }

    #battery {
        color: @green;
    }

    #battery.charging {
        color: @green;
    }

    #battery.warning:not(.charging) {
        color: @red;
    }

    #battery.critical:not(.charging) {
        background-color: #f53c3c;
        color: #ffffff;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
    }

    #network {
        color: @flamingo;
    }

    #backlight {
        color: @yellow;
    }

    #pulseaudio {
        color: @pink;
    }

    #pulseaudio.muted {
        color: @red;
    }

    #custom-power {
        color: @red;
    }

    #tray {
        /*border-radius: 1rem;*/
    }

    tooltip {
        background: @base;
        border: 1px solid @pink;
    }

    tooltip label {
        color: @text;
    }

    #temperature.critical {
        background-color: #eb4d4b;
    }

    #taskbar button:hover {
        background: rgba(0, 0, 0, 0.2);
        box-shadow: inset 0 3px #ffffff;
    }

    #taskbar button.active {
        background-color: #64727D;
        box-shadow: inset 0 3px #ffffff;
    }
  '';
}
