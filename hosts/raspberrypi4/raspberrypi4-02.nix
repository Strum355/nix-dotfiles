{ pkgs, ... }: {
  users.users = {
    noah.hashedPassword = "$y$j9T$gFTc6VN36GXwBApFS473g/$spDYbLrNUal0zlLb.vVORRaottLl8PCDR64OYjGmCV1";
    root.hashedPassword = "$y$j9T$2pgtCzjcMw2SYbIdemn.b1$pJP/SA/IL9C.QrjNckWcQKyswusIvuFXPKjN0cW8x67";
  };

  networking.interfaces.end0.ipv4.addresses = [{
    address = "192.168.88.70";
    prefixLength = 24;
  } {
    address = "192.168.0.70";
    prefixLength = 24;
  }];
}