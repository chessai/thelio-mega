{ pkgs, lib, ... }:

{
  nix = {
    nixPath = [ "nixpkgs=${pkgs.path}" ];

    gc.automatic = false;
  };

  nix.settings = {
    trusted-users = [
      "chessai"
      "root"
    ];

    cores = 16;

    substituters = [
      # NixOS.org
      "https://cache.nixos.org"

      # nix-community
      "https://nix-community.cachix.org"

      # clever
      # "http://cache.earthtools.ca"

      # IOG
      #"https://cache.iog.io"

      # IOG-associated?
      #"https://cache.zw3rk.com"
    ];

    trusted-public-keys = [
      # IOG
      #"hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      #"iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="

      # IOG-associated?
      #"loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk="

      # clever
      # "c2d.localnet-1:YTVKcy9ZO3tqPNxRqeYEYxSpUH5C8ykZ9ImUKuugf4c="

      # nix-community
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

  };

  nix.extraOptions = lib.mkOrder 1 ''
    keep-outputs = true
    keep-derivations = true
    auto-optimise-store = false
    experimental-features = nix-command flakes ca-derivations recursive-nix
  '';

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
      permittedInsecurePackages = [ ];
    };

    overlays = [ ];
  };

  time = {
    timeZone = "America/Chicago";
    hardwareClockInLocalTime = false;
  };
}
