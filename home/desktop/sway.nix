{
  colors,
  swayfont,
  modifier,
  ...
}:

{
  wayland.windowManager.sway = {
    enable = true;
    systemd = {
      enable = true;
    };
    config = {
      fonts = {
        names = [ swayfont ];
        style = "Bold";
        size = 11.0;
      };
      gaps = {
        inner = 5;
        outer = 5;
      };
      input = {
        "*" = {
          xkb_layout = "us";
          xkb_options = "caps:swapescape";
        };
      };
      output = {
        "*" = {
          #bg = "${../../artwork/fractal.png} center";
        };
      };
      colors.focused = {
        background = colors.hex colors.dark;
        border = colors.hex colors.primary;
        text = colors.hex colors.light;
        childBorder = colors.hex colors.primary;
        indicator = colors.hex colors.accent;
      };
      window.border = 2;
      inherit modifier;
      keybindings = {
        "${modifier}+d" = "exec rofi -show run | xargs swaymsg exec --";
        "${modifier}+Shift+q" = "kill";
        #"${modifier}+Shift+r" = "reload";
        "${modifier}+f" = "fullscreen";
        "${modifier}+Return" = "exec alacritty";
        "${modifier}+b" = "exec chromium";
        #"${modifier}+p" = "mode power";
        "${modifier}+n" = "exec makoctl dismiss";
        "${modifier}+Shift+n" = "exec makoctl dismiss -a";
        "${modifier}+w" = "exec networkmanager_dmenu";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";

        "${modifier}+Shift+1" = "move container to workspace number 1, workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2, workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3, workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4, workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5, workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6, workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7, workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8, workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9, workspace number 9";

        "${modifier}+j" = "focus left";
        "${modifier}+k" = "focus down";
        "${modifier}+l" = "focus up";
        "${modifier}+Semicolon" = "focus right";

        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";

        "${modifier}+h" = "split h";
        "${modifier}+v" = "split v";
        #"${modifier}+Shift+s" = "move scratchpad";
        #"${modifier}+s" = "scratchpad show";

        "Print" = "exec grim -g \"$(slurp)\"";
      };
      workspaceAutoBackAndForth = true;
      modes = {
        /*
                power = {
                  "q" = "exit";
                  "r" = "exec systemctl reboot";
                  "s" = "exec systemctl poweroff -i";
                  "p" = "mode default";
                  "Escape" = "mode default";
                  "Return" = "mode default";
                };
        */
      };
      bars = [ ];
      startup = [
      ];
    };
  };
}
