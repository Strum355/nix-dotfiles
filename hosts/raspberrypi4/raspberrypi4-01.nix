{ pkgs, ... }: {
  # environment.systemPackages = with pkgs; [
  #   (bittorrent.override { guiSupport = false; })
  # ];

  users.users = {
    noah.hashedPassword = "$y$j9T$gFTc6VN36GXwBApFS473g/$spDYbLrNUal0zlLb.vVORRaottLl8PCDR64OYjGmCV1";
    root.hashedPassword = "$y$j9T$2pgtCzjcMw2SYbIdemn.b1$pJP/SA/IL9C.QrjNckWcQKyswusIvuFXPKjN0cW8x67";
  };

  services.transmission = {
    enable = true;
    downloadDirPermissions = "777";
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-port = 9091;
      rpc-whitelist-enabled = false;
      peer-port = 39584;
      message-level = 3;
    };
  };

  networking.interfaces.end0.ipv4.addresses = [{
    address = "192.168.88.69";
    prefixLength = 24;
  } {
    address = "192.168.0.69";
    prefixLength = 24;
  }];
}