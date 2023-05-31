let
  disks = [ "/dev/nvme0n1" ];
in
{
  #fileSystems."/" =
  #  { device = "thelio-mega/data";
  #    fsType = "zfs";
  #    options = [ "zfsutil" ];
  #  };

  disko.devices = {
    disk.x = {
      type = "disk";
      device = builtins.elemAt disks 0;
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "ESP";
            start = "1MiB";
            end = "512MiB";
            bootable = true;
            fs-type = "fat32";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }

          {
            name = "zfs";
            start = "512MiB";
            end = "-32GiB";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          }

          {
            name = "swap";
            start = "-32GiB";
            end = "100%";
            content = {
              type = "swap";
            };
          }
        ];
      };
    };

    zpool = {
      zroot = {
        type = "zpool";
        mountpoint = "/"; #null;
        postCreateHook = "zfs snapshot zroot@blank";
        rootFsOptions = {
          compression = "lz4";
          acltype = "posixacl";
        };
        datasets =
          let
            dataset = mountpoint: {
              options = {
                canmount = "on";
                compression = "lz4";
                dnodesize = "auto";
                normalization = "formD";
                xattr = "sa";
                inherit mountpoint;
              };
              type = "zfs_fs";
            };
          in
          {
            "data" = dataset "/";
          };
          /*
            "data/etc" = dataset "/etc";
            "data/home" = dataset "/home";
            "data/var" = dataset "/var";
            "data/var/backup" = dataset "/var/backup";
            "data/var/lib" = dataset "/var/lib";
            "data/var/log" = dataset "/var/log";
            "nixos" = {
              options = {
                canmount = "off";
                mountpoint = "none";
              };
              type = "zfs_fs";
            };
            "nixos/nix" = dataset "/nix";
            "nixos/nix/store" = {
              options = {
                atime = "off";
                canmount = "on";
                mountpoint = "/nix/store";
              };
              type = "zfs_fs";
            };
            "nixos/nix/var" = dataset "/nix/var";
            "reserved" = {
              # zfs uses copy on write and requires some free space to delete files when the disk is completely filled
              options = {
                canmount = "off";
                mountpoint = "none";
                reservation = "5GiB";
              };
              type = "zfs_fs";
            };
          };*/
      };
    };
  };

  # we provide our own hardware-configuration.nix
  # disko.enableConfig = false;
}
