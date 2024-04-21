{ pkgs, ... }: {
  imports = [
    (import ./nm-profile.nix 70)
  ];

  users.users = {
    noah.hashedPassword = "$y$j9T$gFTc6VN36GXwBApFS473g/$spDYbLrNUal0zlLb.vVORRaottLl8PCDR64OYjGmCV1";
    # root.hashedPassword = "$y$j9T$2pgtCzjcMw2SYbIdemn.b1$pJP/SA/IL9C.QrjNckWcQKyswusIvuFXPKjN0cW8x67";
  };
}