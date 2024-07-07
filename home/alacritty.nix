{ lib, ... }:

let
  colors = import ./colors.nix { inherit lib; };
in
{
  programs.alacritty = {
    enable = true;

    settings = lib.mkOptionDefault {
      env.TERM = "alacritty";

      colors = {
        draw_bold_text_with_bright_colors = true;

        primary = {
          background = colors.hex colors.dark;
          foreground = colors.hex colors.light;
        };
      };

      font = {
        size = 18.0;


        normal = {
          family = "Fira Code Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "Fira Code Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "Fira Code Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "Fira Code Nerd Font";
          style = "Bold Italic";
        };
      };
    };
  };
}
