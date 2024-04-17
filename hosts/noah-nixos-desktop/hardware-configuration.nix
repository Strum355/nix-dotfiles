{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.extraModprobeConfig = ''
    # https://wiki.gentoo.org/wiki/Iwlwifi/en#.22Microcode_SW_error_detected._Restarting_0x0.22_message_in_kernel_logs
    options iwlmvm power_scheme=1
  '';

  fileSystems."/" = {
    device = "rpool/nixos";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/nixstore";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DB5B-B0DE";
    fsType = "vfat";
  };

  fileSystems."/run/media/noah/0BCDC3D34ABFF201" = {
    device = "/dev/disk/by-uuid/0BCDC3D34ABFF201";
    fsType = "ntfs";
    options = [
      "x-gvfs-show"
      "x-gvfs-name=Overflow"
      "defaults"
      "nofail"
      "uid=noah"
      "windows_names"
      "users"
    ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
