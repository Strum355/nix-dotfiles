{ config, pkgs, lib, ... }:
let user = "noah";
in {
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    # pro league email scraping mitigation 
    userEmail = lib.concatStrings [ "${user}" "@" "santschi-cooney" ".ch" ];
    userName = "Noah Santschi-Cooney";
    signing = {
      key = "3B22282472C8AE48";
      signByDefault = true;
    };
    aliases = {
      lg =
        "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      pushf = "push --force-with-lease";
      addall = "add --all";
      commitm = "commit -m";
      ff = "pull --ff-only";
      rbmain = "pull --rebase origin main";
      rbmaster = "pull --rebase origin master";
      rbumain = "pull --rebase upstream main";
      rbumaster = "pull --rebase upstream master";
    };
    extraConfig = {
      core = { editor = "${pkgs.nano}/bin/nano"; };
      url."git@github.com:".insteadOf = "https://github.com/";
      push = {
        default = "current";
        autoSetupRemote = true;
      };
    };
  };

  services.picom = {
    enable = true;
    backend = "xrender";
    shadow = false;
    menuOpacity = 0.9;
    inactiveOpacity = 1.0;
    vSync = false;
    settings = {
      refresh-rate = 60;
      glx-no-stencil = true;
      glx-copy-from-front = true;
      glx-swap-method = 1;
      xrender-sync-fence = true;
      wintypes = {
        tooltip = {
          fade = true;
          shadow = false;
          opacity = 0.75;
        };
        utility = { shadow = false; };
      };
    };
  };

  services.polybar = {
    enable = true;
    script =
      "polybar default --config=${config.xdg.configHome}/polybar/config.ini &";
    settings = {
      "bar/default" = {
        monitor = "DP-4.8";
        bottom = false;
        font-0 = "MonoStroom for Powerline:size=9"; # text
        font-1 =
          "Font Awesome 6 Free:size=9:style=Solid"; # globe, antenna signal
        font-2 =
          "Noto Sans Symbols 2:size=9"; # no sound, volume 1, volume 2, volume 3, disk
        font-3 = "Noto Sans Mono:size=9"; # bars
        modules.left = "window";
        modules.right =
          "zfs-nixos zfs-nixstore zfs-home cpu memory volume wired-network wireless-network date";

        module.margin = 1;
        height = 16;

        background = "#000000ff";
        foreground = "#ccffffff";
        border.size = "2pt";

        line.color = "\${bar/default.background}";
        line.size = 16;

        separator = "|";

        locale = "en_US.UTF-8";
      };

      "module/window" = {
        type = "internal/xwindow";
        label.text = "%title%";
        label.maxlen = 100;
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format = "<label> <ramp-coreload>";
        label = "CPU";

        ramp.coreload-0.text = "%{T4}▁%{T-}";
        ramp.coreload-0.font = 5;
        ramp.coreload-0.foreground = "#aaff77";
        ramp.coreload-1.text = "%{T4}▂%{T-}";
        ramp.coreload-1.font = 5;
        ramp.coreload-1.foreground = "#aaff77";
        ramp.coreload-2.text = "%{T4}▃%{T-}";
        ramp.coreload-2.font = 5;
        ramp.coreload-2.foreground = "#aaff77";
        ramp.coreload-3.text = "%{T4}▄%{T-}";
        ramp.coreload-3.font = 5;
        ramp.coreload-3.foreground = "#aaff77";
        ramp.coreload-4.text = "%{T4}▅%{T-}";
        ramp.coreload-4.font = 5;
        ramp.coreload-4.foreground = "#fba922";
        ramp.coreload-5.text = "%{T4}▆%{T-}";
        ramp.coreload-5.font = 5;
        ramp.coreload-5.foreground = "#fba922";
        ramp.coreload-6.text = "%{T4}▇%{T-}";
        ramp.coreload-6.font = 5;
        ramp.coreload-6.foreground = "#ff5555";
        ramp.coreload-7.text = "%{T4}█%{T-}";
        ramp.coreload-7.font = 5;
        ramp.coreload-7.foreground = "#ff5555";
      };

      "module/date" = {
        type = "internal/date";
        date.text = "%A, %d %B %Y (%d/%m/%y) %H:%M";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 3;
        format = "<label>";
        label = "RAM %gb_used%/%gb_total%";
      };

      "module/wired-network" = {
        type = "internal/network";
        interface = "eno1";
        interval = 10;
        label.connected = "%{T2}🖥️%{T-} %local_ip%";
        label.disconnected.foreground = "#66";
      };

      "module/wireless-network" = {
        type = "internal/network";
        interface = "wlp6s0";
        interval = 10;
        label.connected = "%{T2}📶%{T-} %local_ip%";
        label.disconnected.foreground = "#66";
      };

      "module/volume" = {
        type = "internal/alsa";
        master.mixer = "Master";
        #headphone-mixer = Headphone
        #headphone-id = 9

        format.volume = "<ramp-volume><label-volume>";
        label.muted.text = "%{T3}🔇%{T-} 00%";
        label.muted.foreground = "#aa";

        ramp.volume-0 = "%{T3}🔈%{T-} ";
        ramp.volume-1 = "%{T3}🔉%{T-} ";
        ramp.volume-2 = "%{T3}🔊%{T-} ";
      };

      "module/powermenu" = {
        type = "custom/menu";

        label-open = "Menu |";
        label-close = "Close ->";

        # menu-0-0.text = "Terminate WM ";
        # menu-0-0.foreground = "#fba922";
        # menu-0-0.exec = "bspc quit -1";
        # menu-0-1.text = "Reboot ";
        # menu-0-1.foreground = "#fba922";
        # menu-0-1.exec = "menu_open-1";
        # menu-0-2.text = "Power off ";
        # menu-0-2.foreground = "#fba922";
        # menu-0-2.exec = "menu_open-2";

        menu-0-0.text = "Cancel ";
        menu-0-0.foreground = "#fba922";
        menu-0-0.exec = "menu_open-0";
        menu-0-1.text = "Reboot ";
        menu-0-1.foreground = "#fba922";
        menu-0-1.exec = "reboot";

        menu-1-0.text = "Power off ";
        menu-1-0.foreground = "#fba922";
        menu-1-0.exec = "shutdown now";
        menu-1-1.text = "Cancel ";
        menu-1-1.foreground = "#fba922";
        menu-1-1.exec = "menu_open-0";
      };

      "module/clock" = {
        type = "internal/date";
        interval = 2;
        date = "%%{F#999}%Y-%m-%d%%{F-}  %%{F#fff}%H:%M%%{F-}";
      };

      "module/zfs-nixos" = {
        type = "custom/script";
        interval = 60;
        format = "%{T3}🖴%{T-} <label>";
        exec = "${pkgs.polybar-zfs}/bin/polybar-zfs rpool/nixos";
      };

      "module/zfs-nixstore" = {
        type = "custom/script";
        interval = 60;
        format = "%{T3}🖴%{T-} <label>";
        exec = "${pkgs.polybar-zfs}/bin/polybar-zfs rpool/nixstore";
      };

      "module/zfs-home" = {
        type = "custom/script";
        interval = 60;
        format = "%{T3}🖴%{T-} <label>";
        exec = "${pkgs.polybar-zfs}/bin/polybar-zfs rpool/home";
      };
    };
  };

  #########################################
  ##         Mod1 = ALT key              ##
  ##         Mod2 = Num Lock             ##
  ##         Mod3 = unset                ##
  ##         Mod4 = Super key            ##
  #########################################
  #xsession.enable = true;
  #xsession.scriptPath = ".hm-xsession";
  xsession.windowManager.i3 = let
    alt = "Mod1";
    # numlock = "Mod2";
    # <unset> = "Mod3" ;
    super = "Mod4";
  in {
    enable = false;
    config = rec {
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${pkgs.rofi}/bin/rofi";

      fonts = {
        names = [ "monospace" ];
        size = 9.0;
      };

      modifier = super;

      floating = {
        modifier = "Control";
        criteria = [
          { class = "Pavucontrol"; }
          { class = "Calendar"; }
          { class = "zoom"; }
          { title = "Zoom Meeting"; }
        ];
      };

      window = {
        hideEdgeBorders = "both";
        commands = [{
          criteria = { class = ".*"; };
          command = "border pixel 0";
        }];
      };

      focus = {
        mouseWarping = false;
        followMouse = false;
      };

      gaps = {
        inner = 15;
        top = -5;
      };

      startup = [{ command = "${pkgs.nitrogen}/bin/nitrogen --restore"; }];

      assigns = {
        "2" = [ { class = "^discord$"; } { class = "^telegram-desktop$"; } ];
      };

      keybindings = with pkgs; {
        "Print" = "exec ${flameshot}/bin/flameshot full -c";
        "Shift+Print" = "exec ${flameshot}/bin/flameshot gui -r | ${xclip}/bin/xclip -selection clipboard -t image/png";
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+c" = "exec ${gnome.zenity}/bin/zenity --calendar";
        
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+r" = "restart";
        
        "${modifier}+d" = "exec ${menu} -show drun";
        "${alt}+Tab" = "exec ${menu} -show window";

        # "${modifier}+Shift+c"
        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";

        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";

        "${modifier}+h" = "split h";
        "${modifier}+v" = "split v";

        "${modifier}+f" = "fullscreen toggle";

        "${modifier}+Shift+s" = "layout stacking";
        "${modifier}+Shift+w" = "layout tabbed";
        "${modifier}+Shift+e" = "layout toggle split";

        "${modifier}+Shift+space" = "floating toggle";

        # "${modifier}+a" = "focus parent";
        # "${modifier}+d" = "focus"

        "${modifier}+1}" = "workspace 1";
        "${modifier}+2}" = "workspace 2";
        "${modifier}+Shift+1" = "move container to workspace 1";
        "${modifier}+Shift+2" = "move container to workspace 2";

        "Control+${alt}+l" = "exec dm-tool lock";

        "${modifier}+r" = ''mode "resize"'';

        "XF86AudioRaiseVolume" = "exec amixer -q set Master 5%+ unmute";
        "XF86AudioLowerVolume" = "exec amixer -q set Master 5%- unmute";
        "XF86AudioMute" = "exec amixer -q set Master toggle";
        "${modifier}+XF86AudioRaiseVolume" = "exec amixer -q set Master 1%+ unmute && pkill -RTMIN+1 i3blocks";
        "${modifier}+XF86AudioLowerVolume" = "exec amixer -q set Master 1%- unmute && pkill -RTMIN+1 i3blocks";
        "XF86AudioPlay" = "exec playerctl play";
        "${modifier}+Ctrl+space" = "exec playerctl play-pause";

        "${modifier}+slash" = "exec splatmoji copy";
      };

      modes = {
        resize = {
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";

          # back to normal: Enter or Escape
          "Return" = ''mode "default"'';
          "Escape" = ''mode "default"'';
        };
      };

      bars = [
        # TODO: test empty
      ];

      colors = let
        bgColor = "#2f343f";
        inactiveBgColor = "#2f343f";
        inactiveBorderColor = "#585c65";
        textColor = "#f3f4f5";
        inactiveTextColor = "#676e7d";
        urgentBgColor = "#e53935";
        indicatorColor = "#a0a0a0";
      in {
        focused = {
          border = bgColor;
          background = bgColor;
          text = textColor;
          indicator = indicatorColor;
          childBorder = "#285577";
        };
        unfocused = {
          border = inactiveBorderColor;
          background = inactiveBgColor;
          text = inactiveTextColor;
          indicator = indicatorColor;
          childBorder = "#222222";
        };
        focusedInactive = {
          border = inactiveBorderColor;
          background = inactiveBgColor;
          text = inactiveTextColor;
          indicator = indicatorColor;
          childBorder = "#5f676a";
        };
        urgent = {
          border = urgentBgColor;
          background = urgentBgColor;
          text = textColor;
          indicator = indicatorColor;
          childBorder = "#900000";
        };
      };
    };
    extraConfig = ''
      tiling_drag off
    '';
  };
}
