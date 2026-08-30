{ colors, ... }:

{
  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "bottom";
        position = "top";
        height = 40;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "network"
          "clock"
        ];
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
        network = {
          format-wifi = "{essid} {signalStrength}%";
          format-ethernet = "{ifname}";
          format-disconnected = "disconnected";
          on-click = "networkmanager_dmenu";
          tooltip-format = "{ifname} via {gwaddr}";
        };
      }
    ];

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
      targets = [ "sway-session.target" ];
    };
  };
}
