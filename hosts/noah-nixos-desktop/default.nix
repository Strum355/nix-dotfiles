{ inputs, self }:
inputs.nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";
  specialArgs = inputs;
  modules = [
    inputs.agenix.nixosModules.default
    {
      environment.systemPackages = [ inputs.agenix.packages.${system}.default ]; 
    }
    {
      nixpkgs.overlays = (builtins.attrValues self.overlays) ++ [
        inputs.nix-ld-rs.overlays.default
      ];
    }
    ./configuration.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.noah = import ../../home.nix;
    }
  ];
}