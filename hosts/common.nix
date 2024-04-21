{ pkgs, nixpkgs, ... }: {
  networking = {
    nameservers = [ 
      "1.1.1.1" 
      "8.8.8.8" 
      "2606:4700:4700::1111"
      "2001:4860:4860::8888"
    ];
  };

  services.resolved = {
    enable = true;
    # For some reason we get the following error on aarch64, but not x86_64
    # Failed to invoke SSL_do_handshake: error:16000069:STORE routines::unregistered scheme 
    dnsovertls = if pkgs.hostPlatform.isx86_64 then "true" else "false";
    # epic gaming 
    # https://sourcegraph.com/github.com/NixOS/nixpkgs@a61c6b478d80952fad5be7fc499f0b9b681c9b58/-/blob/nixos/modules/system/boot/resolved.nix?L89-93
    dnssec = "false";
    extraConfig = ''
      Cache=yes
    '';
  };

  time.timeZone = "Europe/Dublin";

  i18n.defaultLocale = "en_US.UTF-8";

  users.mutableUsers = false;
  users.users.noah = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" ];
    home = "/home/noah";
    createHome = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxukBpm9PDBd8Nb9Vz+I68qA6NOHGdyEEMdukPNhAKZ"
    ];
  };

  programs = {
    command-not-found.enable = false;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixVersions.unstable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      keep-outputs = true;
      trusted-users = [ "root" "noah" ];
    };
    
    gc.automatic = true;
    optimise.automatic = true;
    registry = { nixpkgs.flake = nixpkgs; };
    nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];
  };
}