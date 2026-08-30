{ ... }:

{
  xdg.configFile."environment.d/envvars.conf".text = ''
    MOZ_ENABLE_WAYLAND=1
    MOZ_USE_XINPUT2=1
    XDG_CURRENT_DESKTOP=sway
    XDG_SESSION_TYPE=wayland
  '';

  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = rofi -dmenu
    rofi_highlight = True
    compact = True
    pinentry = pinentry-gnome3
  '';
}
