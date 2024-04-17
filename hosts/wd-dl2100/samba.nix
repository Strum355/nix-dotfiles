{ ... }:
{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;

    shares = {
      smbalex = {
        "path" = "/mnt/nasdata/smbalex";
        "writable" = "true";
        "create mask" = "0700";
        "directory mask" = "0700";
        "force user" = "smbalex";
        "force group" = "smbalex";
        "browseable" = "yes";
      };
      smbnoah = {
        "path" = "/mnt/nasdata/smbnoah";
        "writable" = "true";
        "create mask" = "0700";
        "directory mask" = "0700";
        "force user" = "smbnoah";
        "force group" = "smbnoah";
        "browseable" = "yes";
      };
    };

    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbnix
      netbios name = smbnix
      smb encrypt = required
      browseable = yes
      protocol = SMB3
      client min protocol = SMB3
      server min protocol = SMB3
      guest account = nobody
      map to guest = bad user
      log level = 3
    '';
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # bit inconsistent because I didn't set these ahead of time, setting now
  # so they don't end up being randomized again.
  users.groups.smbalex = { gid = 997; };
  users.users.smbalex = { isSystemUser = true; group = "smbalex"; uid = 998; };
  users.groups.smbnoah = { gid = 996; };
  users.users.smbnoah = { isSystemUser = true; group = "smbnoah"; uid = 997; };
}