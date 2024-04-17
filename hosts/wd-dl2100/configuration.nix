{ pkgs, nixpkgs, ...}:
{
  imports = [
    ./hardware-configuration.nix
    ./samba.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    entryOptions = "--class nixos --unrestricted --id nixos-primary";
    # if only onboard wasnt h*cked : )
    extraEntries = ''
      menuentry "OnBoard GRUB" {
        insmod configfile
        search --no-floppy --set=root --label wdnas_efi
        configfile /EFI/BOOT/grub.cfg
      }
    '';
  };
  boot.loader.systemd-boot.enable = false;

  services.udisks2.enable = true;

  users.mutableUsers = false;
  users.users.noah = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "$y$j9T$/squSDBLJ7/mIlg59uB2.0$vAwTXsKivSl7Bxi/7yRouleGVne1KBn/9xnvB61NvND";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxukBpm9PDBd8Nb9Vz+I68qA6NOHGdyEEMdukPNhAKZ"
    ];
  };

  time.timeZone = "Europe/Dublin";

  documentation.man.enable = false;

  environment.systemPackages = with pkgs; [
    htop
    setserial
    file
    tree
    dmidecode
    bintools
    grub2_efi
    fanctl
    lm_sensors
    wdnas-hwdaemon
  ];

  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  services.wdnas-hwdaemon.enable = true;

  networking = {
    useDHCP = false;
    firewall.enable = true;
    enableIPv6 = false;
    hostName = "noah-wd-dl2100";
    bonds.bond0 = {
      interfaces = ["enp0s20f0" "enp0s20f1"];
      driverOptions = {
        miimon = "1000";
        mode = "802.3ad";
      };
    };
    interfaces = {
      bond0 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "192.168.88.210";
          prefixLength = 24;
        } {
          address = "192.168.0.210";
          prefixLength = 24;
        }];
      };
      enp0s20f0.useDHCP = false;
      enp0s20f1.useDHCP = false;
    };
  };

  nix = {
    package = pkgs.nixVersions.unstable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      keep-outputs = true;
      trusted-users = [ "root" "noah" ];
      allowed-users = [ "root" "noah" ];
    };

    gc.automatic = true;
    optimise.automatic = true;
    registry = { nixpkgs.flake = nixpkgs; };
    nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];
  };

  system.stateVersion = "24.05";
}