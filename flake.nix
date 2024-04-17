{
  description = "strum355's nix dotfiles";

  nixConfig = {
    extra-substituters = [ "https://personal-systems.cachix.org" ];
    extra-trusted-public-keys = [ "personal-systems.cachix.org-1:yhmUti+2iOTrBWtmZGA71zaPbdQM7iE1k7X9VALPzXM=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
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

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      forAllSystems = fn: nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ] (system: fn (nixpkgs.legacyPackages.${system}));
    in {
      nixosConfigurations = {
        noah-nixos-desktop = import ./hosts/noah-nixos-desktop { inherit inputs self; };
      };

      overlays = (import ./util.nix).mkOverlays self.packages;
      packages = forAllSystems (pkgs': 
        let
          # does this override consumers' setting or will it error later? also apparently precludes x-compile
          pkgs = import nixpkgs {
            system = pkgs'.system;
            config.allowUnfree = true;
          };
        in {
          monostroom = pkgs.callPackage ./pkgs/monostroom.nix { };
          code2000 = pkgs.callPackage ./pkgs/code2000.nix { };
          polybar-zfs = pkgs.callPackage ./pkgs/polybar-zfs.nix { };
          psgrep = pkgs.callPackage ./pkgs/psgrep.nix { };
          splatmoji = pkgs.callPackage ./pkgs/splatmoji.nix { };
          # causes way too much to be rebuilt
          # polkit = pkgs.callPackage ./pkgs/polkit.nix { };
        });
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
