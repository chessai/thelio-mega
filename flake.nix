{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-26.05";

    disko = {
      url = "github:nix-community/disko/4677f6c53482a8b01ee93957e3bdd569d51261d6";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    extract.url = "github:chessai/extract";

    nix-colors.url = "github:misterio77/nix-colors";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-configs = {
      url = "github:chessai/nvim-configs";
    };

    polymc.url = "github:PolyMC/PolyMC";

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
      nix-colors,
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
          ./configuration.nix
          ({ ... }: {
            home-manager.users.chessai.home.packages = [
              nvim-configs.packages.${system}.neovim
            ];
          })
          {
            nixpkgs.overlays = [
              polymc.overlay
            ];
          }
          #({ pkgs, ... }: {
          #  nixpkgs.overlays = [ fenix.overlays.default ];
          #  environment.systemPackages =
          #    let
          #      base-fenix = pkgs.fenix.complete.withComponents [
          #        "cargo"
          #        "clippy"
          #        "rust-src"
          #        "rustc"
          #        "rustfmt"
          #      ];
          #      full-fenix = fenix.packages.${system}.combine [
          #        base-fenix
          #        fenix.packages.${system}.targets.wasm32-unknown-unknown.latest.rust-std
          #      ];
          #    in
          #    [
          #      full-fenix
          #      pkgs.rust-analyzer-nightly
          #      pkgs.trunk
          #    ];
          #})
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
