{ ... }:

{
  _module.args = {
    swayfont = "source-code-pro 10";
    modifier = "Mod4";
  };

  imports = [
    ./mako.nix
    ./rofi.nix
    ./session.nix
    ./sway.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar.nix
  ];
}
