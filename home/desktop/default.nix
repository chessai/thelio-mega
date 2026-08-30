{ lib, ... }:

{
  _module.args = {
    swayfont = "source-code-pro 10";
    modifier = "Mod4";
    colors = import ../colors.nix { inherit lib; };
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
