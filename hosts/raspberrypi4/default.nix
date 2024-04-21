{ inputs, self }:
let
  mkPi = hostname: inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = { inherit (inputs) nixpkgs; };
    modules = [
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      { nixpkgs.overlays = [ self.overlays.psgrep ]; }
      ./configuration.nix
      { imports = [ ./${hostname}.nix ]; }
      { networking.hostName = hostname; }
    ];
  };
in
{
  raspberrypi4-milo = mkPi "raspberrypi4-milo";
  raspberrypi4-watoto = mkPi "raspberrypi4-watoto";
  raspberrypi4-miradan = mkPi "raspberrypi4-miradan";
}
