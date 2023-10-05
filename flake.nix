{
  description = "strum355's nix dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-otel = {
      url = "github:lf-/nix-otel";
      # inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, nix-otel, nix-ld-rs }@inputs:
    {
      nixosConfigurations.noah-nixos-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          { nixpkgs.overlays = builtins.attrValues self.overlays; }
          { nixpkgs.overlays = [ nix-otel.overlays.default nix-ld-rs.overlays.default ]; }
          ./hosts/noah-nixos-desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.noah = import ./home.nix;
          }
        ];
      };

      overlays = (import ./util.nix).mkOverlays self.packages;
    } // flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = builtins.attrValues self.overlays;
      };
      packages = # does this override consumers' setting or will it error later? also apparently precludes x-compile
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in {
          monostroom = pkgs.callPackage ./pkgs/monostroom.nix { };
          code2000 = pkgs.callPackage ./pkgs/code2000.nix { };
          fish = pkgs.callPackage ./pkgs/fish.nix { };
          polybar-zfs = pkgs.callPackage ./pkgs/polybar-zfs.nix { };
          psgrep = pkgs.callPackage ./pkgs/psgrep.nix { };
          splatmoji = pkgs.callPackage ./pkgs/splatmoji.nix { };
          # causes way too much to be rebuilt
          # polkit = pkgs.callPackage ./pkgs/polkit.nix { };
        };
      formatter = nixpkgs.legacyPackages.${system}.nixfmt;
    });
}
