{ pkgs, ... }:

{
  services.smartd.enable = true;
  hardware.rasdaemon.enable = true;
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
    # NixOS defaults to keeping 12 monthlies; that retention tail is a
    # measurable performance cost on a pool that already carries ~530
    # snapshots. One monthly is enough history for a desktop.
    autoSnapshot.monthly = 1;
  };

  # zfs-auto-snapshot only prunes its own frequency classes; this is the
  # ad-hoc tool for old manual snapshots and datasets it doesn't manage.
  environment.systemPackages = [ pkgs.zfs-prune-snapshots ];

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/5a899c16-a86c-4671-b39c-f31eaea40d82";
    fsType = "ext4";
  };

  # no metadata write on reads
  fileSystems."/nix/store".options = [ "noatime" ];
}
