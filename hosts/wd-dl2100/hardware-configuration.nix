{ lib, modulesPath, ... }:
{
  imports = [ 
    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/base.nix")
    (modulesPath + "/profiles/headless.nix")
  ];

  boot = {
    growPartition = true;
    kernelParams = lib.mkBefore ["console=ttyS1,115200n8"];
    loader.grub = {
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    loader.timeout = 2;
    initrd.availableKernelModules = ["uas"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true;
    # options = [ "defaults" "mode=755" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  fileSystems."/mnt/nasdata" = {
    device = "nashdds/data";
    fsType = "zfs";
  };

  fileSystems."/mnt/nasdata/smbalex" = {
    device = "nashdds/smbalex";
    fsType = "zfs";
  };

  fileSystems."/mnt/nasdata/smbnoah" = {
    device = "nashdds/smbnoah";
    fsType = "zfs";
  };

  fileSystems."/mnt/nasdata/smbshare" = {
    device = "nashdds/smbshare";
    fsType = "zfs";
  };
}