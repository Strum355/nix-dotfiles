{ pkgs, lib, modulesPath, ... }: {
  imports = [ 
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/headless.nix")

    ./hardware-configuration.nix 
    ../common.nix
  ];

  sdImage.compressImage = false;

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    vim
    wget
    coreutils
    tree
    openssh
    htop
    unzip
    file
    patchelf
    jq
    bind.dnsutils
    psgrep
    wirelesstools
    traceroute
    ndisc6
  ];

  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  networking = {
    useDHCP = false;
    firewall.enable = true;
    interfaces.end0 = {
      tempAddress = "disabled";
    };
    networkmanager = {
      enable = true;
      plugins = lib.mkForce [ ];
      dns = "systemd-resolved";
      logLevel = "INFO";
    };
  };

  xdg = {
    icons.enable = false;
    sounds.enable = false;
  };

  users.groups.gpio = {};
  services.udev.extraRules = ''
    SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
    SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio  /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
    SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
  '';

  system.stateVersion = "24.05";
}