{ pkgs, ... }:

{
  ### section plex
  services.plex = {
    enable = true;
    openFirewall = true;

    user = "plex";
    group = "plex";

    dataDir = "/var/lib/plex";
  };

  users.users.plex.extraGroups = [
    "users"
    "video"
    "render"
  ];

  #systemd.tmpfiles.rules = [
  #  "Z /mnt/data/media 0755 plex video - -"
  #];

  systemd.services.fix-media-permissions = {
    description = "Fix plex media directory permissions";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/chgrp -R video /mnt/data/media && ${pkgs.coreutils}/bin/chmod -R g+w /mnt/data/media'";
    };
  };

  #hardware.opengl = {
  #  enable = true;
  #  driSupport = true;
  #  driSupport32Bit = true;
  #};

  ### end section plex
}
