{ lib, ... }:

let
  disks = [ "/dev/nvme0n1" ];
in
{
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
        mountpoint = null;
        #mountRoot = "/mnt";
        postCreateHook = "zfs snapshot zroot@genesis";
        rootFsOptions = {
          compression = "on";
          acltype = "posixacl";
        };
        datasets =
          let
            dataset = mountpoint: {
              options = {
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

            dontSnapshot = d: lib.recursiveUpdate d {
              options."com.sun:auto-snapshot" = "false";
            };
          in
          {
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
            "data/coredumps" = dataset "/var/lib/systemd/coredump";

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
