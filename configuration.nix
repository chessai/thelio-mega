{ pkgs, modulesPath, config, ... }:

let
  secrets = import ./secrets.nix;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    #./file-systems.nix
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
      };

      efi.canTouchEfiVariables = false;
    };

    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    zfs = {
      devNodes = "/dev";
      forceImportRoot = false;
      forceImportAll = false;
    };

    kernelParams = [
      "boot.shell_on_fail"
      "panic=30"
      # "boot.panic_on_fail" # reboot the machine upon fatal boot issues
    ];

    # cleanup /tmp on boot
    tmp.cleanOnBoot = true;
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "without-password";
  };

  users.users.root.openssh.authorizedKeys.keys = import ./chessai-ssh-keys.nix;

  networking = {
    wireless = {
      enable = true;
      networks = {
        attinternet.psk = secrets.attinternet.psk;
      };
    };

    firewall = {
      enable = true;
    };

    hostId = "8425e349";
    hostName = "thelio_mega";
  };

  #services.timesyncd.enable = false;

  environment.systemPackages = [
    pkgs.coreutils
    pkgs.util-linux
  ];

  system.stateVersion = "23.05";
}
