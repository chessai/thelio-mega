{ ... }:

{
  services.smartd.enable = true;
  hardware.rasdaemon.enable = true;
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/5a899c16-a86c-4671-b39c-f31eaea40d82";
    fsType = "ext4";
  };

  # no metadata write on reads
  fileSystems."/nix/store".options = [ "noatime" ];
}
