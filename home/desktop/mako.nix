{ colors, ... }:

{
  services.mako.settings = {
    enable = true;
    anchor = "top-right";
    background-color = colors.hex colors.dark;
    text-color = colors.hex colors.light;
    border-color = colors.hex colors.primary;
    border-radius = 5;
    border-size = 2;
    font = "SourceCodePro 18";
  };
}
