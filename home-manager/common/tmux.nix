{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
    programs.tmux = {
        enable = true;
        clock24 = true;
        shell = "${pkgs.zsh}/bin/zsh";
        terminal = "tmux-256color";
        historyLimit = 100000;
        plugins = with pkgs; [
            tmuxPlugins.better-mouse-mode
            tmuxPlugins.catppuccin
        ];
        extraConfig = '' # used for less common options, intelligently combines if defined in multiple places.
            set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
            run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
            set -g @catppuccin_flavour 'frappe'
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_date_time "%H:%M"
        '';
    };
}