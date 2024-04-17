{ config, pkgs, lib, ... }:
let user = "noah";
in {
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  programs.fish = {
    # enable = true;
    functions = {
      wdiff = "bash -c '${pkgs.wdiff}/bin/wdiff -n -w ${lib.escapeNixString "\$'\033[30;31m'"} -x ${lib.escapeNixString "\$'\033[0m'"} -y ${lib.escapeNixString "\$'\033[30;32m'"} -z ${lib.escapeNixString "\$'\033[0m'"} $argv[1..-1]";
    };
    shellInit = ''
      set -x GOPATH $HOME/Go
      set -x RUST_BACKTRACE 1
      set -x KUBECONFIG $HOME/kubeconfig
      set -x EDITOR nano
    '';

    loginShellInit = ''
      set -U PATH $HOME/.bin $HOME/.local/bin $GOPATH/bin $HOME/.cargo/bin $PATH
    '';

    interactiveShellInit = ''
      set fish_greeting ""
      set -g theme_title_display_process yes
      set -g theme_title_use_abbreviated_path no
      set -g theme_show_exit_status yes
      set -g theme_color_scheme terminal
      set -g theme_display_k8s_context yes
      set -g theme_display_date no
    '';

    shellAliases = {
      g = "git";
      k = "kubectl";
      mk = "minikube";
      devx = "pushd ~/Sourcegraph/dev-infra-scratch/ && code 2024/log.snb.md";
    };
  };

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
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
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

  programs.rofi = {
    enable = true;
    # package = pkgs.rofi.override { plugins = with pkgs; [ rofi-pass ]; };
    cycle = true;
    font = "mono 14";
    extraConfig = {
      show-icons = true;
    };
    theme = let inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        red = mkLiteral "rgba(30, 50, 47, 100%)";
        blue = mkLiteral "rgba(38, 139, 210, 100%)";
        lightfg = mkLiteral "rgba(33, 37, 43, 100%)";
        separatorcolor = mkLiteral "var(foreground)";
        lightbg = mkLiteral "rgba(40, 44, 52, 100%)";
        background-color = mkLiteral "rgba(0, 0, 0, 0%)";
        border-color = mkLiteral "var(foreground)";
        
        background = mkLiteral "rgba(33, 37, 43, 100%)";
        normal-background = mkLiteral "rgba(40, 44, 52, 100%)";
        active-background = mkLiteral "var(background)";
        urgent-background = mkLiteral "var(background)";
        selected-active-background = mkLiteral "rgba(40, 44, 52, 100%)";
        selected-urgent-background = mkLiteral "var(red)";
        selected-normal-background = mkLiteral "var(lightfg)";
        alternate-normal-background = mkLiteral "var(lightbg)";
        alternate-active-background = mkLiteral "var(lightbg)";
        alternate-urgent-background = mkLiteral "var(lightbg)";
        
        foreground = mkLiteral "rgba(207, 216, 220, 100%)";
        normal-foreground = mkLiteral "var(foreground)";
        active-foreground = mkLiteral "rgba(207, 216, 220, 100%)";
        urgent-foreground = mkLiteral "var(red)";
        selected-normal-foreground = mkLiteral "rgba(168, 169, 161, 100%)";
        selected-active-foreground = mkLiteral "var(selected-normal-foreground)";
        selected-urgent-foreground = mkLiteral "var(background)";
        alternate-normal-foreground = mkLiteral "var(foreground)";
        alternate-active-foreground = mkLiteral "var(blue)";
        alternate-urgent-foreground = mkLiteral "var(red)";

        spacing = 2;
      };
      "element" = {
        padding = mkLiteral "1px";
        spacing = mkLiteral "5px";
        border = 0;
      };
      "element normal.normal" = {
        background-color = mkLiteral "var(normal-background)";
        text-color = mkLiteral "var(normal-foreground)";
      };
      "element normal.urgent" = {
        background-color = mkLiteral "var(urgent-background)";
        text-color = mkLiteral "var(urgent-foreground)";
      };
      "element normal.active" = {
        background-color = mkLiteral "var(active-background)";
        text-color = mkLiteral "var(active-foreground)";
      };
      "element selected.normal" = {
        background-color = mkLiteral "var(selected-normal-background)";
        text-color = mkLiteral "var(selected-normal-foreground)";
      };
      "element selected.urgent" = {
        background-color = mkLiteral "var(selected-urgent-background)";
        text-color = mkLiteral "var(selected-urgent-foreground)";
      };
      "element selected.active" = {
        background-color = mkLiteral "var(selected-active-background)";
        text-color = mkLiteral "var(selected-active-foreground)";
      };
      "element alternate.normal" = {
        background-color = mkLiteral "var(alternate-normal-background)";
        text-color = mkLiteral "var(alternate-normal-foreground)";
      };
      "element alternate.urgent" = {
        background-color = mkLiteral "var(alternate-urgent-background)";
        text-color = mkLiteral "var(alternate-urgent-foreground)";
      };
      "element alternate.active" = {
        background-color = mkLiteral "var(alternate-active-background)";
        text-color = mkLiteral "var(alternate-active-foreground)";
      };
      "element-text" = {
        background-color = mkLiteral "rgba(0, 0, 0, 0%)";
        highlight = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "element-icon" = {
        background-color = mkLiteral "rgba(0, 0, 0, 0%)";
        size = mkLiteral "1.0000em";
        text-color = mkLiteral "inherit";
      };
      "window" = {
        padding = 5;
        background-color = mkLiteral "var(background)";
        border = 2;
        width = mkLiteral "1000px";
      };
      "mainbox" = {
        padding = 0;
        border = 0;
      };
      "message" = {
        padding = mkLiteral "1px";
        border-color = mkLiteral "var(separatorcolor)";
        border = mkLiteral "2px dash 0px 0px";
      };
      "textbox" = { text-color = mkLiteral "var(foreground)"; };
      "listview" = {
        padding = mkLiteral "2px 0px 0px";
        scrollbar = true;
        border-color = mkLiteral "var(separatorcolor)";
        spacing = mkLiteral "2px";
        fixed-height = 0;
        border = mkLiteral "2px dash 0px 0px";
      };
      "scrollbar" = {
        width = mkLiteral "4px";
        padding = 0;
        handle-width = mkLiteral "8px";
        border = 0;
        handle-color = mkLiteral "var(normal-foreground)";
      };
      "sidebar" = {
        border-color = mkLiteral "var(separatorcolor)";
        border = mkLiteral "2px dash 0px 0px";
      };
      "button" = {
        spacing = 0;
        text-color = mkLiteral "var(normal-foreground)";
      };
      "button selected" = {
        background-color = mkLiteral "var(selected-normal-background)";
        text-color = mkLiteral "var(selected-normal-foreground)";
      };
      "num-filtered-rows" = {
        expand = false;
        text-color = mkLiteral "rgba(128, 128, 128, 100%)";
      };
      "num-rows" = {
        expand = false;
        text-color = mkLiteral "rgba(128, 128, 128, 100%)";
      };
      "textbox-num-sep" = {
        expand = false;
        str = "/";
        text-color = mkLiteral "rgba(128, 128, 128, 100%)";
      };
      "inputbar" = {
        padding = mkLiteral "1px";
        spacing = mkLiteral "0px";
        text-color = mkLiteral "var(normal-foreground)";
        children = mkLiteral ''[ 
          prompt,
          textbox-prompt-colon,
          entry,
          num-filtered-rows,
          textbox-num-sep,
          num-rows,
          case-indicator
        ]'';
      };
      "case-indicator" = {
        spacing = 0;
        text-color = mkLiteral "var(normal-foreground)";
      };
      "entry" = {
        text-color = mkLiteral "var(normal-foreground)";
        spacing = 0;
        placeholder-color = mkLiteral "rgba(128, 128, 128, 100%)";
        placeholder = "Type to filter";
      };
      "prompt" = {
        spacing = 0;
        text-color = mkLiteral "var(normal-foreground)";
      };
      "textbox-prompt-colon" = {
        margin = mkLiteral "0px 0.3000em 0.0000em 0.0000em";
        expand = false;
        str = ":";
        text-color = mkLiteral "inherit";
      };
    };
  };

  services.picom = {
    enable = true;
    backend = "xrender";
    shadow = false;
    menuOpacity = 0.9;
    inactiveOpacity = 1.0;
    vSync = true;
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
    package = pkgs.polybar.override { i3Support = true; };
    script = "polybar default --config=${config.xdg.configHome}/polybar/config.ini &";
    settings = {
      "bar/default" = {
        monitor = "DP-4";
        bottom = false;
        font-0 = "MonoStroom for Powerline:size=9"; # text
        font-1 = "Font Awesome 6 Free:size=9:style=Solid"; # globe, antenna signal
        font-2 = "Noto Sans Symbols 2:size=9"; # no sound, volume 1, volume 2, volume 3, disk
        font-3 = "Noto Sans Mono:size=9"; # bars
        modules.right = "zfs-nixos zfs-nixstore zfs-home temperature cpu memory volume wired-network wireless-network date";

        module.margin = 1;
        height = 16;

        background = "#000000ff";
        foreground = "#ccffffff";
        border.size = "2pt";

        line.color = "\${bar/default.background}";
        line.size = 16;

        separator = "|";

        locale = "en_US.UTF-8";

        tray-position = "left";
        tray-padding = 5;
      };

      "module/window" = {
        type = "internal/xwindow";
        label.text = "%title%";
        label.maxlen = 100;
      };

      "module/temperature" = {
        type = "internal/temperature";
        units = true;
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
  # xsession.enable = true;
  # xsession.scriptPath = ".hm-xsession";
  xsession.windowManager.i3 = let
    alt = "Mod1";
    # numlock = "Mod2";
    # <unset> = "Mod3" ;
    super = "Mod4";
  in {
    enable = true;
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

        "${modifier}+1" = "workspace 1";
        "${modifier}+2" = "workspace 2";
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

      bars = [];

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
