{ config, pkgs, lib, ... }:
let 
  types = lib.types;
  cfg = config.services.wdnas-hwdaemon;
in {
  options.services.wdnas-hwdaemon = {
    enable = lib.mkEnableOption "hwdaemon service";

    socket = lib.mkOption {
      default = "/run/wdhwd/hws.sock";
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.wdnas-hwdaemon = {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.wdnas-hwdaemon}/bin/wdhwd --config /etc/wdhwd/wdhwd.conf";
        ExecStop = "${pkgs.wdnas-hwdaemon}/bin/wdhwc -q shutdown";
        StandardOutput = "inherit";
        Restart = "always";
        RestartPreventExitStatus = [ 10 11 ];
        KillMode = "mixed";
      };
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ bash python3 util-linux systemd hddtemp smartmontools sudo ];
    };

    users.groups.wdhwd = { };
    users.users.wdhwd = {
      isSystemUser = true;
      createHome = false;
      group = "wdhwd";
    };

    environment.systemPackages = [ pkgs.wdnas-hwdaemon ];

    environment.etc."wdhwd/wdhwd.conf".text = lib.generators.toINI {} {
      # hardcode for now, can always parameterize later :shrug:
      wdhwd = {
        socket_path = cfg.socket;
        logging = ":W";
        lcd_intensity_normal = 100;
        lcd_intensity_dimmed = 60;
        lcd_dim_timeout = 60;
        fan_speed_normal = 10;
        fan_speed_increment = 10;
        fan_speed_decrement = 10;
        # for some reason, array-typed fields are parsed as JSON instead of the configparser-native format
        # https://sourcegraph.com/github.com/michaelroland/wdnas-hwdaemon@9fc05963b05b2f50b5c19b14c3776b4f1545a0a4/-/blob/lib/daemonize/config.py?L134-146
        additional_drives = (builtins.toJSON []);
      };
    };

    security.sudo.extraConfig = ''
      Defaults:wdhwd secure_path="${lib.makeBinPath (with pkgs; [ systemd hddtemp smartmontools sudo ])}"
    '';
    security.sudo.extraRules = [{
      users = [ "wdhwd" ];
      host = "ALL";
      runAs = "root";
      commands = [
        {
          command = "${pkgs.hddtemp}/bin/hddtemp -n -u C /dev/sd?";
          options = [ "NOPASSWD" "NOEXEC" "NOMAIL" "NOSETENV" ];
        }
        {
          command = "${pkgs.smartmontools}/bin/smartctl -n idle\\,128 -A /dev/sd?";
          options = [ "NOPASSWD" "NOEXEC" "NOMAIL" "NOSETENV" ];
        }
        {
          command = "${pkgs.systemd}/bin/shutdown -P now";
          options = [ "NOPASSWD" "NOEXEC" "NOMAIL" "NOSETENV" ];
        }
        {
          command = "${pkgs.systemd}/bin/shutdown -P +60";
          options = [ "NOPASSWD" "NOEXEC" "NOMAIL" "NOSETENV" ];
        }
        {
          command = "${pkgs.systemd}/bin/shutdown -c";
          options = [ "NOPASSWD" "NOEXEC" "NOMAIL" "NOSETENV" ];
        }
      ];
    }];
  };
}
