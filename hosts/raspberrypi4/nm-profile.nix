ipNum: { lib, config, ... }: 
let 
  ipNumStr = builtins.toString ipNum;
  addressAttrsToStrs = addresses: builtins.foldl' (acc: elem: acc // elem) {} (lib.imap1 (i: addr: {
    "address${builtins.toString i}" = "${addr.address}/${builtins.toString addr.prefixLength}";
  }) addresses);
in rec {
  networking.interfaces.end0.ipv4.addresses = [{
    address = "192.168.0.${ipNumStr}";
    prefixLength = 24;
  } {
    address = "192.168.88.${ipNumStr}";
    prefixLength = 24;
  }];
  
  networking.networkmanager.ensureProfiles.profiles = {
    "end0" = {
      "connection" = {
        "id" = "end0";
        "interface-name" = "end0";
        "type" = "ethernet";
      };
      "ipv4" = {
        "method" = "manual";
        "gateway" = "192.168.0.1";
        # no way to set address-data with keyfiles it seems...sticking with the
        # "deprecated" method of setting addresses
      } // addressAttrsToStrs networking.interfaces.end0.ipv4.addresses;
      "ipv6" = {
        "method" = "auto";
        "addr-gen-mode" = "eui64";
        "ip6-privacy" = 0;
        "ignore-auto-dns" = true;
      };
    };
  };
}