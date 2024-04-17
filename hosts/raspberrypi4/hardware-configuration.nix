{ lib, ... }: {
  boot = {
    initrd = {
      availableKernelModules = lib.mkForce [ 
        "bcm2835_dma"
        "i2c_bcm2835"
        "pcie_brcmstb"
        "reset-raspberrypi"
        "sdhci_pci"
        "uas"
        "usb_storage"
        "usbhid"
        "vc4"
        "xhci_pci"
      ];
      includeDefaultModules = false;
      kernelModules = [ "dm_mod" "ext4" "dwc2" ];
    };
    kernelParams = [ "modules-load=dwc2,g_serial" "8250.nr_uarts=1" ];
    loader.raspberryPi.firmwareConfig = ''
      droverlay=dwc2
    '';
    supportedFilesystems = lib.mkForce [ "vfat" "ext4" "ntfs" ];
  };

  fileSystems = {
    "/" = {
      # one day mSATA
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };
}