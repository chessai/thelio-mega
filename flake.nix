{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, disko, nixos-hardware, ... }:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.thelio-mega = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        nixos-hardware.nixosModules.system76
        disko.nixosModules.disko
        ./configuration.nix
      ];
    };
  };
}
