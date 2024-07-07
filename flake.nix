{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    disko = {
      url = "github:nix-community/disko/4677f6c53482a8b01ee93957e3bdd569d51261d6";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    extract.url = "github:chessai/extract";

    nix-colors.url = "github:misterio77/nix-colors";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-configs = {
      url = "github:chessai/nvim-configs";
    };

    chainwebNode.url = "github:kadena-io/chainweb-node/bbaa5f5ebd57947d7e20a131cf242be4cf66b2a1";
    chainwebModule.url = "github:kadena-io/chainweb-node-nixos-module";

    jj = {
      url = "github:martinvonz/jj";
    };
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
      jj,
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
          ./disk-config.nix
          extract.nixosModules.${system}.extract
          home-manager.nixosModules.home-manager
          ./configuration.nix
          ({ ... }: {
            home-manager.users.chessai.home.packages = [
              nvim-configs.packages.${system}.neovim
              jj.packages.${system}.jujutsu
            ];
          })
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
