{
  description = "strum355's nix dotfiles";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-otel = {
      url = "github:lf-/nix-otel";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, nix-otel }@attrs:
    {
      nixosConfigurations.noah-nixos-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          { nixpkgs.overlays = builtins.attrValues self.overlays; }
          { nixpkgs.overlays = [ nix-otel.overlays.default ]; }
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
        };
      formatter = nixpkgs.legacyPackages.${system}.nixfmt;
    });
}
