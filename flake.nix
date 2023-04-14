{
  description = "strum355's nix dotfiles";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    nixosConfigurations."noah-nixos-desktop" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/noah-nixos-desktop/configuration.nix ];
    };
  };
}
