{ modulesPath, ... }:

let
  disks = [ "/dev/nvme0n1" ];
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (import ./disk-config.nix { inherit disks; })
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        devices = disks;
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
      };

      efi.canTouchEfiVariables = false;
    };

    zfs = {
      devNodes = "/dev";
      forceImportRoot = false;
      forceImportAll = false;
    };

    kernelParams = [
      "boot.shell_on_fail"
      "panic=30"
      "boot.panic_on_fail" # reboot the machine upon fatal boot issues
    ];

    # cleanup /tmp on boot
    tmp.cleanOnBoot = true;
  };

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = import ./chessai-ssh-keys.nix;

  networking = {
    hostId = "17e169db";
    hostName = "chessai-thelio_mega";
  };

  system.stateVersion = "23.05";
}
