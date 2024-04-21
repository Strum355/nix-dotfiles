{ pkgs, ... }: {
  imports = [
    (import ./nm-profile.nix 69)
  ];

  users.users = {
    noah.hashedPassword = "$y$j9T$3mq0K8kfutuuq8wAZpS6Q.$Dj/mcvaw12DtqqmAoN3gL1Y4uMFsanDsFHeFieQ1jJA";
    # root.hashedPassword = "$y$j9T$2pgtCzjcMw2SYbIdemn.b1$pJP/SA/IL9C.QrjNckWcQKyswusIvuFXPKjN0cW8x67";
  };

  networking.firewall = {
    allowedTCPPorts = [ 9091 39584 ];
    allowedUDPPorts = [ 39584 ];
  };

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    downloadDirPermissions = "777";
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-port = 9091;
      rpc-whitelist-enabled = false;
      peer-port = 39584;
      port-forwarding-enabled = false;
      message-level = 6;
    };
  };
}