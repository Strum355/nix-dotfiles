{ inputs, self }:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = inputs;
  modules = [ 
    { nixpkgs.overlays = builtins.attrValues self.overlays; }
    inputs.nixos-generators.nixosModules.all-formats
    ./configuration.nix
    self.nixosModules.wdnas-hwdaemon
  ];
}