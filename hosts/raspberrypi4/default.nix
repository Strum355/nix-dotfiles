{ inputs, self }:
let 
mkPi = hostname: inputs.nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  specialArgs = {
    inherit hostname self;
    inherit (inputs) nixpkgs;
  };
  modules = [ 
    { nixpkgs.overlays = [ self.overlays.psgrep ]; }
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ./configuration.nix 
  ];
};
in {
  # TODO: give em some nice snazzy names
  raspberrypi4-01 = mkPi "raspberrypi4-01";
  raspberrypi4-02 = mkPi "raspberrypi4-02";
  raspberrypi4-03 = mkPi "raspberrypi4-03";
}