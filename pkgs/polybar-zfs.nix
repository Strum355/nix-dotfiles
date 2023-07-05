{ bc, zfs, coreutils, gnused, writeShellApplication }:
writeShellApplication {
  name = "polybar-zfs";

  runtimeInputs = [ zfs coreutils bc gnused ];

  text = builtins.readFile ./polybar-zfs.sh;
}
