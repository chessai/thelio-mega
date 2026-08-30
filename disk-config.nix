{ lib, ... }:

let
  dataset = mountpoint: {
    options = {
      atime = "off"; # don't generate metadata entries for every single read
      canmount = "on";
      compression = "on";
      dnodesize = "auto";
      normalization = "formD";
      xattr = "sa";
      mountpoint = "legacy";
      "com.sun:auto-snapshot" = "true";
    };
    type = "zfs_fs";
    inherit mountpoint;
  };

  dontSnapshot =
    d:
    lib.recursiveUpdate d {
      options."com.sun:auto-snapshot" = "false";
    };

  dontMount =
    d:
    lib.recursiveUpdate d {
      options.canmount = "off";
    };
in
{
  disko.devices = {

    # 1TB M2
    disk.x = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          # `label` is pinned to the on-disk GPT partition names (which predate
          # the gpt-type migration); disko would otherwise derive
          # `gpt-x-<name>` and the by-partlabel device paths would not resolve.
          ESP = {
            priority = 1;
            label = "ESP";
            type = "EF00";
            start = "1M";
            end = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          zfs = {
            priority = 2;
            label = "zfs";
            end = "-32G";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };

          swap = {
            priority = 3;
            label = "swap";
            size = "100%";
            content = {
              type = "swap";
            };
          };
        };
      };
    };

    zpool = {
      zroot = {
        type = "zpool";
        mountpoint = null;
        #mountRoot = "/mnt";
        postCreateHook = "zfs snapshot zroot@genesis";
        rootFsOptions = {
          compression = "on";
          acltype = "posixacl";
        };
        datasets = {
          "data" = dataset "/";
          "data/etc" = dataset "/etc";
          "data/home" = dataset "/home";
          "data/home/chessai" = dataset "/home/chessai";
          "data/var" = dataset "/var";
          #"data/var/backup" = dataset "/var/backup";
          "data/var/lib" = dataset "/var/lib";
          "data/var/lib/docker" = dontSnapshot (dataset "/var/lib/docker");
          "data/var/log" = dataset "/var/log";

          "nixos" = {
            options = {
              canmount = "off";
              mountpoint = "none";
            };
            type = "zfs_fs";
          };
          "nixos/nix" = dataset "/nix";
          "nixos/nix/store" = dontSnapshot {
            options = {
              atime = "off";
              canmount = "on";
              mountpoint = "legacy";
            };
            type = "zfs_fs";
            mountpoint = "/nix/store";
          };
          "nixos/nix/var" = dataset "/nix/var";

          # coredumps are rather large, and can expire quickly,
          # so that conflicts with zfs snapshots saving every byte,
          # so it's on its own dataset with no snapshots
          "data/coredumps" = dontSnapshot (dataset "/var/lib/systemd/coredump");

          # zfs uses copy on write and requires some free space to delete files when the disk is completely filled
          "reserved" = {
            options = {
              canmount = "off";
              mountpoint = "none";
              reservation = "5GiB";
            };
            type = "zfs_fs";
          };
        };
      };
    };
  };
}
