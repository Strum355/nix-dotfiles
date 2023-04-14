{
  description = "strum355's nix dotfiles";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          packages = {
            monostroom = pkgs.callPackage ./pkgs/monostroom.nix { };
            code2000 = pkgs.callPackage ./pkgs/code2000.nix { };
          };
        }
      ) // {
      overlays = {
        monostroom = prev: final: { monostroom = final.callPackage ./pkgs/monostroom.nix { }; };
        code2000 = prev: final: { code2000 = final.callPackage ./pkgs/code2000.nix { }; };
      };
      nixosConfigurations."noah-nixos-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            nixpkgs.overlays = [
              self.overlays.monostroom
              self.overlays.code2000
            ];
          }
          ./hosts/noah-nixos-desktop/configuration.nix
        ];
      };
    };
}
