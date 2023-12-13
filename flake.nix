{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    extract.url = "github:chessai/extract";

    nix-colors.url = "github:misterio77/nix-colors";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-configs = {
      url = "github:chessai/nvim-configs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chainwebNode.url = "github:kadena-io/chainweb-node";
    chainwebModule.url = "github:kadena-io/chainweb-node-nixos-module";
  };

  outputs =
    {
      disko,
      extract,
      home-manager,
      nix-colors,
      nixpkgs,
      nixos-hardware,
      nvim-configs,
      chainwebModule,
      chainwebNode,
      self,
      ...
    }:
  let
    system = "x86_64-linux";
  in
  {
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
          ({ ... }: { home-manager.users.chessai.home.packages = [ nvim-configs.packages.${system}.neovim ]; })
          {
            nixpkgs.overlays = [
              (self: super: {
                chainweb-node = chainwebNode.packages.${system}.default;
              })
            ];
          }
          chainwebModule.nixosModules.chainweb-node
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
