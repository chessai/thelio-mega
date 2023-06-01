{ config, ... }:

let
  hostName = config.networking.hostName;
in
{
  fileSystems."/" =
    { device = "${hostName}/data";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/etc" =
    { device = "${hostName}/data/etc";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home" =
    { device = "${hostName}/data/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var" =
    { device = "${hostName}/data/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/backup" =
    { device = "${hostName}/data/var/backup";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/lib" =
    { device = "${hostName}/data/var/lib";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/log" =
    { device = "${hostName}/data/var/log";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/nix" =
    { device = "${hostName}/nixos/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/nix/store" =
    { device = "${hostName}/nixos/nix/store";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/nix/var" =
    { device = "${hostName}/nixos/nix/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/boot" =
    { device = null; #"/dev/disk/by-uuid/D1E3-1422";
      fsType = "vfat";
    };

  swapDevices =
    [
      { device = null; };
    ];
}
