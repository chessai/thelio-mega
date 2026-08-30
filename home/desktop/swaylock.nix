{ config, ... }:

let
  colors = config.colorscheme.colors;
in
{
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
}
