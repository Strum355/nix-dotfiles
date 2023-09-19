{ lib, pkgs, nixpkgs, ... }:
let
  lockBackground = builtins.path {
    path = ./lock-background.jpg;
    name = "slick-lock-background";
  };
in {
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "zfs" "ntfs" ];

    kernel.sysctl."net.ipv4.conf.all.arp_ignore" = 1;
    kernel.sysctl."net.ipv4.conf.all.arp_announce" = 1;
    kernelParams = [ "zfs.zfs_arc_max=4294967296" ];
  };

  networking = {
    firewall.enable = false;
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    hostName = "noah-nixos-desktop";
    hostId = "8425e349";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      extraConfig = ''
        [connection-wifi-wlp6s0]
        match-device=interface-name:wlp6s0
        ipv4.route-metric=10

        [connection-eth-eno1]
        match-device=interface-name:eno1
        ipv4.route-metric=100
      '';
    };
    extraHosts = ''
      127.0.0.1 sourcegraph.test
    '';
    interfaces.eno1 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.88.251";
        prefixLength = 24;
      }];
    };
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
  };

  time.timeZone = "Europe/Dublin";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    packages = [ pkgs.terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-114n.psf.gz";
  };

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-emoji-blob-bin
      noto-fonts-extra
      noto-fonts-lgc-plus
      joypixels
      dejavu_fonts
      fira-code
      font-awesome_4
      font-awesome_6
      font-awesome_5
      monostroom
      code2000
      twemoji-color-font
      twitter-color-emoji
      openmoji-black
      openmoji-color
      inconsolata
      _3270font
      comic-mono
      comic-relief
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      hinting = {
        enable = true;
        autohint = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      allowBitmaps = true;
      useEmbeddedBitmaps = true;
      defaultFonts = {
        inherit (import ./fonts.nix) monospace sansSerif emoji serif;
      };
    };
  };

  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;

  location = {
    latitude = 52.3379105;
    longitude = -6.4560767;
  };

  # services.geoclue2.enable = true;
  services.redshift = {
    enable = true;
    temperature.night = 4500;
  };
  services.xserver = {
    enable = true;
    exportConfiguration = true;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ dmenu rofi polybar ];
      #extraSessionCommands = ''
      #  eval $(${pkgs.gnome3.gnome-keyring}/bin/gnome-keyring-daemon --daemonize --components=ssh,secrets)
      #  export SSH_AUTH_SOCK
      #'';
    };

    displayManager.defaultSession = "none+i3";
    displayManager.lightdm = {
      enable = true;
      greeter.enable = true;
      greeters.slick = {
        enable = true;
        draw-user-backgrounds = false;
        extraConfig = ''
          [Greeter]
          background=${lockBackground}
          stretch-background-across-monitors=false
        '';
      };
    };

    dpi = 96;
    videoDrivers = [ "nvidia" ];
    screenSection = ''
      Option "metamodes" "DP-4.8: 2560x1440_60 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, HDMI-0: 1920x1080_60 +2560+360"
    '';
  };
  services.picom.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [ 
      vaapiVdpau
      nvidia-vaapi-driver
      libvdpau-va-gl
    ];
  };
  hardware.nvidia.forceFullCompositionPipeline = true;
  hardware.nvidia.modesetting.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  services.fstrim.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ epson-escpr ];
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.openrazer = {
    enable = true;
    users = [ "noah" ];
  };

  users.mutableUsers = false;
  users.users.noah = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" ];
    shell = pkgs.fish;
    home = "/home/noah";
    createHome = true;
    hashedPassword =
      "$y$jFT$4BKFwYX3OJFl9W6Md0cw./$fS16Nf1gFV3PecFbe5LfzCulv4OoLJFKz8nEfXi.pz0";
  };

  environment.sessionVariables = with pkgs; {
    JAVA_HOME = "${jdk11}/lib/openjdk";
    JAVA_8_HOME = "${jdk8}/lib/openjdk";
    JAVA_11_HOME = "${jdk11}/lib/openjdk";
    JAVA_17_HOME = "${jdk17}/lib/openjdk";
    JAVA_19_HOME = "${jdk19}/lib/openjdk";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };

  environment.pathsToLink = [ "/libexec" "/share/nix-direnv" ];
  environment.systemPackages = with pkgs; [
    vim
    git
    git-crypt
    wget
    coreutils
    man
    tree
    mkpasswd
    thunderbird
    vscode
    gparted
    pass
    openssh
    (discord.override { withOpenASAR = true; })
    slack
    jetbrains.idea-ultimate
    jetbrains.idea-community
    jdk8
    jdk11
    jdk17
    jdk19
    kotlin
    go_1_19
    gopls
    python311
    nodejs_20
    maven
    gradle
    synergy
    kitty
    nil
    cinnamon.nemo
    cinnamon.mint-themes
    (cinnamon.mint-y-icons.overrideAttrs (oldAttrs: {
      pname = "mint-l-icons";
      src = pkgs.fetchFromGitHub {
        owner = "linuxmint";
        repo = "mint-l-icons";
        rev = "e9fd3cf2d3f3a22647e9a83da9b16538795fddbb";
        sha256 = "sha256-RDozoknjXqzjQxLgOAaD/BH7hhi5mNlW+Vne93aEt0I=";
      };
    }))
    htop
    coursier
    (adapta-gtk-theme.overrideAttrs (oldAttrs: {
      version = "3.95.0.11-custom";
      src = pkgs.fetchFromGitHub {
        owner = "Strum355";
        repo = "adapta-gtk-theme";
        rev = "26dcba1068bd2ce30328df44a911d14471dac030";
        sha256 = "sha256-MHkR3sUNjeO9A751y3jCdyB4OJhBUZA1X/Sxtx8HOcM=";
      };
    }))
    lxappearance
    flameshot
    gnome.zenity
    gnome.gnome-keyring
    gnome.eog
    gnome.gucharmap
    playerctl
    fzf
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
    wdiff
    diff-so-fancy
    fontconfig
    font-manager
    vlc
    nitrogen
    xclip
    unzip
    file
    gcc
    clang
    telegram-desktop
    zoom-us
    patchelf
    direnv
    nix-direnv
    docker-compose
    graphviz
    jq
    htop
    dunst
    polychromatic
    cachix
    bind.dnsutils
    psgrep
    kubernetes-helm
    kubectl
    gimp
    protobuf
    tidal-hifi
    obs-studio
    openshot-qt
    ffmpeg
    wirelesstools
    postgresql
    (tree-sitter.override { webUISupport = true; })
  ];

  security = {
    polkit.enable = true;
    pam.services.lightdm.enableGnomeKeyring = true;

  };
  services.gnome.gnome-keyring.enable = true;

  services.k3s = {
    enable = false;
    role = "server";
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
    firefox = {
      enable = true;
      nativeMessagingHosts.browserpass = true;
    };
    fish.enable = true;
    browserpass.enable = true;
    dconf.enable = true;
    file-roller.enable = true;
    command-not-found.enable = false;
    evince.enable = true;
    nix-index.enable = true;
    nix-ld.enable = true;
  };

  # services.passSecretService.enable = true;
  services.openssh = {
    enable = true;
    allowSFTP = true;
    banner = import ./ssh-banner.nix;
  };

  virtualisation.docker = {
    rootless.enable = true;
    enable = true;
  };
  systemd.services.docker.wantedBy = lib.mkForce [ ];

  nixpkgs.config.joypixels.acceptLicense = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      nix-direnv = super.nix-direnv.override { enableFlakes = true; };
    })
  ];
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      keep-outputs = true;
      trusted-substituters = [ "https://sourcegraph-noah.cachix.org" ];
      trusted-public-keys = [
        "sourcegraph-noah.cachix.org-1:rTTKnyuUmJuGt/UAXUpdOCOXDAfaO1AYy+/jSre3XgA="
      ];
    };
    extraOptions = ''
      extra-substituters = https://sourcegraph-noah.cachix.org
    '';
    # plugin-files = ${pkgs.nix-otel}/lib/libnix_otel_plugin.so
    gc.automatic = true;
    optimise.automatic = true;
    registry = { nixpkgs.flake = nixpkgs; };
    nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];
  };

  system.stateVersion = "22.11";
}
