{ pkgs, nixpkgs, ... }: {
  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  services.resolved = {
    enable = true;
    # epic gaming 
    # https://sourcegraph.com/github.com/NixOS/nixpkgs@a61c6b478d80952fad5be7fc499f0b9b681c9b58/-/blob/nixos/modules/system/boot/resolved.nix?L89-93
    dnssec = "false";
    extraConfig = ''
      DNSOverTLS=yes
      Cache=yes
    '';
  };

  time.timeZone = "Europe/Dublin";

  i18n.defaultLocale = "en_US.UTF-8";

  users.mutableUsers = false;
  users.users.noah = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" ];
    shell = pkgs.fish;
    home = "/home/noah";
    createHome = true;
  };

  programs = {
    fish.enable = true;
    command-not-found.enable = false;
    nix-index.enable = true;
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