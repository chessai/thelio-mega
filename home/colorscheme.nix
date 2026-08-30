# The colour scheme: a handful of named seed colours, plus everything derived
# from them (role names, light/dark variants) and the maths used to get there.
#
# Lives at the top of home/ rather than in desktop/ because it is consumed from
# outside the desktop (shell/alacritty.nix), and an option is the only binding
# that reaches across those directories.
{ config, lib, ... }:

let
  inherit (lib)
    mkOption
    mkDefault
    types
    mapAttrs
    ;

  colors-lib = import ../lib/colors.nix { inherit lib; };

  cfg = config.colorscheme;
in
{
  options.colorscheme = {
    palette = mkOption {
      type = types.attrsOf types.str;
      description = ''
        The seed colours, as six-digit hex without a leading '#'. These are
        the only colours set by hand; everything else is derived from them.
        The stock palette is supplied below as an ordinary definition rather
        than as an option default, so a single seed can be overridden without
        restating the rest.
      '';
    };

    colors = mkOption {
      type = types.attrsOf types.raw;
      readOnly = true;
      description = ''
        The palette parsed into { red, green, blue } sets, the role names
        (primary/secondary/accent/dark/light, each with a light and a dark
        variant), and the helpers needed to render them: `hex`, `css`,
        `brighten`, `darken`, `rgb-to-hsv`, `hsv-to-rgb`.

        Derived, hence read-only: set `colorscheme.palette` instead.
      '';
    };
  };

  config.colorscheme = {
    palette = mapAttrs (_name: mkDefault) {
      rich-black = "060A16";
      middle-green = "5F9057";
      harvest-gold = "D49221";
      cadet-grey = "97AEBE";
      bittersweet-shimmer = "B85653";
      dark-liver = "45454B";
      malachite = "1ED761";

      black = "000000";
    };

    colors =
      let
        inherit (colors-lib)
          rgb
          hex
          css
          brighten
          darken
          rgb-to-hsv
          hsv-to-rgb
          ;
        palette = mapAttrs (_name: rgb) cfg.palette;
      in
      with palette;
      palette
      // rec {
        red = bittersweet-shimmer;
        green = middle-green;

        primary = bittersweet-shimmer;
        primary-light = brighten primary;
        primary-dark = darken primary;
        secondary = middle-green;
        secondary-light = brighten secondary;
        secondary-dark = darken secondary;
        accent = harvest-gold;
        accent-light = brighten accent;
        accent-dark = darken accent;
        dark = rich-black;
        dark-light = brighten dark;
        dark-dark = darken dark;
        light = cadet-grey;
        light-light = brighten light;
        light-dark = darken light;
        inherit
          hex
          css
          brighten
          darken
          rgb-to-hsv
          hsv-to-rgb
          ;
      };
  };
}
