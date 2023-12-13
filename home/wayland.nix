{ pkgs, lib, ... }:

let
  swayfont = "source-code-pro 10";
  modifier = "Mod4";
  colors = import ./colors.nix { inherit lib; };
in
{
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
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
      bars = [];
      startup = [
      ];
    };
  };

  xdg.configFile."environment.d/envvars.conf".text = ''
    MOZ_ENABLE_WAYLAND=1
    MOZ_USE_XINPUT2=1
    XDG_CURRENT_DESKTOP=sway
    XDG_SESSION_TYPE=wayland
  '';

  programs.waybar = {
    enable = true;
    settings = [{
      layer = "bottom";
      position = "top";
      height = 40;
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
      modules-right = [ "clock" ];
      "sway/window" = {
        format = "{}";
        max-length = 50;
      };
      "sway/mode" = {
        format = "{}";
      };
      clock = {
        format = "{:%H:%M}";
        tooltip-format = "{:%Y-%m-%d | %H:%M}";
        format-alt = "{:%Y-%m-%d}";
      };
    }];

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: 'Source Code Pro', 'Font Awesome 5';
        font-size: 20px;
        min-height: 0;
      }
      window#waybar {
        background: ${colors.css colors.dark 0.5};
        border-bottom: 3px solid ${colors.css colors.primary 0.5};
        color: ${colors.hex colors.light};
      }
      window#waybar.hidden {
        opacity: 0.0;
      }
      #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: ${colors.hex colors.light};
        border-bottom: 3px solid transparent;
      }
      #workspaces button.focused {
        background: ${colors.hex colors.primary};
        border-bottom: 3px solid ${colors.hex colors.dark};
      }
      #workspaces button.urgent {
        background-color: ${colors.hex colors.red};
      }
      #clock, #cpu, #memory, #temperature, #backlight, #network, #pulseaudio, #mode, #idle_inhibitor {
        padding: 0 10px;
        margin: 0 5px;
      }
    '';

    systemd = {
      enable = true;
      target = "sway-session.target";
    };
  };

  programs.rofi.enable = true;

  programs.swaylock.settings = {
    screenshots = true;
    clock = true;
    indicator = true;
    show-failed-attempts = true;
    ignore-empty-password = true;
    grace = 2;
    effect-blur = "7x5";
    effect-vignette = "0.6:0.6";
    ring-color = colors.hex colors.accent;
    ring-ver-color = colors.hex colors.green;
    ring-wrong-color = colors.hex colors.red;
    key-hl-color = colors.hex colors.primary;
    line-color = "00000000";
    line-ver-color = "00000000";
    line-wrong-color = "00000000";
    inside-color = "00000000";
    inside-ver-color = "00000000";
    inside-wrong-color = "00000000";
    separator-color = "00000000";
    text-color = colors.hex colors.light;
  };

  services.mako = {
    enable = true;
    anchor = "top-right";
    backgroundColor = colors.hex colors.dark;
    textColor = colors.hex colors.light;
    borderColor = colors.hex colors.primary;
    borderRadius = 5;
    borderSize = 2;
    font = "SourceCodePro 18";
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "swaylock -f";
      }
      {
        timeout = 600;
        command = "swaymsg 'output * dpms off'";
        resumeCommand = "swaymsg 'output * dpms on'";
      }
    ];
  };
}
