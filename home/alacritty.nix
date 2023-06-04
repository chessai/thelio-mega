{ lib, /*colors, */ ... }:

{
  programs.alacritty = {
    enable = true;

    settings = lib.mkOptionDefault {
      env.TERM = "alacritty";
      draw_bold_text_with_bright_colors = true;
      font = {
        size = 18.0;

        #colors = {
        #  primary = {
        #    background = colors.hex colors.dark;
        #    foreground = colors.hex colors.light;
        #  };
        #};

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
