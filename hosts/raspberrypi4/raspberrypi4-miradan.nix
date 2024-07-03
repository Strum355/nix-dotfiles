{ pkgs, config, ... }: {
  imports = [
    (import ./nm-profile.nix 71)
  ];

  users.users = {
    noah.hashedPassword = "$y$j9T$xhxV5eGp6emRnH6ekJuRY.$85DgLL9thY0CegrQGRq.rQRDrUk.JDTN9MIutdXco02";
    # root.hashedPassword = "$y$j9T$2pgtCzjcMw2SYbIdemn.b1$pJP/SA/IL9C.QrjNckWcQKyswusIvuFXPKjN0cW8x67";
  };

  networking.firewall = {
    allowedTCPPorts = [ 
      config.services.prometheus.port
      config.services.grafana.settings.server.http_port
    ];
  };

  services.prometheus = {
    enable = true;
    port = 9090;
    scrapeConfigs = [{
      job_name = "node_exporters";
      static_configs = [{
        targets = [ "192.168.0.210:9100" "192.168.0.69:9100" "192.168.0.71:9100"];
      }];
    }];
  };

  services.grafana = {
    enable = true;
    settings = {
      server.protocol = "http";
      server.http_addr = "0.0.0.0";
      server.http_port = 3000;
    };
    provision = {
      enable = true;
      datasources.settings = {
        apiVersion = 1;
        datasources = [{
          name = "Prometheus";
          type = "prometheus";
          # the uid grafana decided to assign it because I didn't
          uid = "PBFA97CFB590B2093";
          url = "http://localhost:${toString config.services.prometheus.port}";
          jsonData = {
            timeInterval = "1m";
          };
        }];
      };
      dashboards.settings = {
        apiVersion = 1;
        providers = [{
          name = "Dashboards";
          options.path = "/etc/grafana-dashboards";
        }];
      };
      # dashboards.path = "${path-to-generating-derivation}"
    };
  };
}