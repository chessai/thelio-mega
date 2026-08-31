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

    nvim-configs = {
      url = "github:chessai/nvim-configs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
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
      self,
      treefmt-nix,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};

      # One formatter for the whole repo: nixfmt (RFC-style) over every *.nix
      # file. Exposed twice - as `formatter` (what `nix fmt` runs) and as a
      # check (what `nix flake check` verifies).
      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        # pkgs.nixfmt *is* nixfmt-rfc-style as of nixpkgs 25.05; the
        # nixfmt-rfc-style attribute is now an alias that warns on eval.
        programs.nixfmt.enable = true;
      };
    in
    {
      formatter.${system} = treefmtEval.config.build.wrapper;

      # `nix flake check` should mean "both configurations still build, and the
      # tree is formatted" - anything weaker proves nothing about this repo.
      checks.${system} = {
        toplevel = self.nixosConfigurations.thelio-mega.config.system.build.toplevel;
        iso = self.nixosConfigurations.iso.config.system.build.toplevel;
        formatting = treefmtEval.config.build.check self;
      };

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
              nixpkgs.overlays = import ./overlays { inherit maestro; };
              # Make maestro's home-manager module (`services.maestro`, MAE-047)
              # available to every home-manager user; enabled per-user in
              # home/dev/maestro.nix.
              home-manager.sharedModules = [ maestro.homeManagerModules.default ];
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
