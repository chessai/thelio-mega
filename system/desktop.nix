{ pkgs, lib, ... }:

{
  services.dbus.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.polkit.enable = true;

  # screen sharing section
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
  # end screen sharing section

  fonts = {
    packages =
      with pkgs;
      [
        dejavu_fonts
        font-awesome
        freefont_ttf
        liberation_ttf_v2
        lmodern
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        powerline-fonts
        source-han-sans
        source-han-serif
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    /*
      error: nerdfonts has been separated into individual font packages under the namespace nerd-fonts.
         For example change:
           fonts.packages = [
             ...
             (pkgs.nerdfonts.override { fonts = [ "0xproto" "DroidSansMono" ]; })
           ]
         to
           fonts.packages = [
             ...
             pkgs.nerd-fonts._0xproto
             pkgs.nerd-fonts.droid-sans-mono
           ]
         or for all fonts
           fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
    */
    #fontconfig.defaultFonts = {
    #  serif = [ "Noto Serif" "Source Han Serif" ];
    #  sansSerif = [ "Noto Sans" "Source Han Sans" ];
    #};
  };

  programs.java.enable = true;
  programs.steam = {
    enable = true;
    #package = pkgs.steam.override { withJava = true; };
  };

  # install a shim at the FHS loader path that redirects to the real glibc
  # loader via NIX_LD. if a missing .so is encountered, you can add it to
  # `programs.nix-ld.libraries`.
  programs.nix-ld.enable = true;
}
