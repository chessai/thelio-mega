{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-26.05";

    disko = {
      url = "github:nix-community/disko/4677f6c53482a8b01ee93957e3bdd569d51261d6";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    extract = {
      url = "github:chessai/extract";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    maestro = {
      url = "github:chessai/maestro";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # No inputs.nixpkgs.follows: nvim-configs references nodePackages.*, which
    # was removed from nixpkgs, so it only evaluates against its own pin.
    nvim-configs = {
      url = "github:chessai/nvim-configs";
    };

    polymc = {
      url = "github:PolyMC/PolyMC";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      disko,
      extract,
      fenix,
      home-manager,
      maestro,
      nixpkgs,
      nixos-hardware,
      nvim-configs,
      polymc,
      self,
      ...
    }:
  let
    system = "x86_64-linux";
  in
  {
    packages.${system}.default = fenix.packages.${system}.minimal.toolchain;

    diskoConfigurations.thelio-mega = import ./disk-config.nix;

    nixosConfigurations = {
      thelio-mega = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixos-hardware.nixosModules.system76
          disko.nixosModules.disko
          extract.nixosModules.${system}.extract
          home-manager.nixosModules.home-manager
          ./system
          ({ ... }: {
            home-manager.users.chessai.home.packages = [
              nvim-configs.packages.${system}.neovim
            ];
          })
          {
            nixpkgs.overlays = import ./overlays { inherit polymc maestro; };
          }
        ];
      };

      iso = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./iso.nix
        ];
      };
    };
  };
}
