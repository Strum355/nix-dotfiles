{ lib, pkgs, nixpkgs, hostname, self, ... }: {
  imports = [ 
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    "${nixpkgs}/nixos/modules/profiles/minimal.nix"
    "${nixpkgs}/nixos/modules/profiles/headless.nix"

    ./hardware-configuration.nix 
    ../common.nix
    ./${hostname}.nix
  ];

  sdImage.compressImage = false;

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    vim
    git
    git-crypt
    wget
    coreutils
    man
    tree
    mkpasswd
    openssh
    # why have this?
    (pass.override {
      x11Support = false;
      dmenuSupport = false;
      waylandSupport = false;
    })
    htop
    fzf
    # shouldn't have fish on servers...unless
    fishPlugins.foreign-env
    fishPlugins.fzf-fish
    (fishPlugins.bobthefish.overrideAttrs (oldAttrs: {
      version = "08-05-2023";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "theme-bobthefish";
        rev = "ed896b65c3ddbdf2929c38719adfb940b0d9b90d";
        sha256 = "sha256-DRMBZS8nT0rhKXQEGWNqR1FUavtvxH0xUdHU52WhSJQ=";
      };
    }))
    unzip
    file
    patchelf
    jq
    bind.dnsutils
    psgrep
    wirelesstools
    traceroute
    ndisc6
    nmap
  ];

  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };

  systemd.network.enable = true;
  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
  systemd.network.networks = {
    "10-wan" = {
      matchConfig = {
        Name = "end0";
      };
      # need to make sure all this actually works
      networkConfig = {
        DHCP = "ipv6";
        IPv6AcceptRA = true;
        LinkLocalAddressing = "ipv6";
        IPv6LinkLocalAddressGenerationMode = "eui64";

      };
      dhcpV6Config = {
        UseAddress = true;
        UseHostname = false;
        UseDNS = false;
        UseNTP = false;
        DUIDType = "link-layer";
      };
    };
  };

  networking = {
    useDHCP = false;
    firewall.enable = false;
    # this works, right? :clueless:
    interfaces.end0.ipv4.routes = [{
      address = "default";
      via = "192.168.88.1";
      prefixLength = 0;
    } {
      address = "default";
      via = "192.168.0.1";
      prefixLength = 0;
    }];
    dhcpcd = {
      enable = false;
      allowInterfaces = [ "end0" ];
      denyInterfaces = [ "wlan0" ];
      extraConfig = ''
        debug

        nohook resolv.conf

        interface end0
        ipv6only
        slaac hwaddr
        # why disable?
        fqdn disable
      '';
    };
    interfaces.end0 = {
      useDHCP = false;
    };
  };

  xdg = {
    icons.enable = false;
    sounds.enable = false;
  };

  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };

  systemd.services."serial-getty@tty0" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };

  users.groups.gpio = {};

  # double check what this is for
  services.udev.extraRules = ''
    SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
    SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio  /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
    SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
  '';

  system.stateVersion = "23.11";
}