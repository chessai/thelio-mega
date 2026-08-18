{ pkgs, lib, modulesPath, config, ... }:

let
  secrets = import ./secrets.nix;

  #hsDocPackage = p: lib.getOutput "doc" p // {
  #  pname = p.identifier.name;
  #  haddockDir = p.haddockDir;
  #};

  #bruh = packageInputs: builtins.map hsDocPackage (flatLibDepends {
  #  depends = packageInputs;
  #  libs = [];
  #  pkgconfig = [];
  #  frameworks = [];
  #  doExactConfig = false;
  #});
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./home
  ];

  boot = {
    tmp.useTmpfs = true;

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

  services.smartd.enable = true;
  hardware.rasdaemon.enable = true;
  services.zfs.autoScrub.enable = true;

  services.openssh = {
    enable = true;
  };

  networking = {
    enableIPv6 = false; # something is wrong with my network, ipv6 keeps causing issues

    # use NetworkManager
    wireless.enable = false; # no wpa_supplicant
    networkmanager.enable = true; # use NetworkManager

    firewall = {
      enable = true;
      extraCommands = ''
        # Create OUTPUT chain if it doesn't exist, then add accept rule for all
        # outgoing traffic
        #${pkgs.nftables}/bin/nft add chain ip filter OUTPUT '{ type filter hook output priority 0; policy accept; }' 2>/dev/null || true
        #${pkgs.nftables}/bin/nft add chain ip6 filter OUTPUT '{ type filter hook output priority 0; policy accept; }' 2>/dev/null || true
      '';
    };

    nameservers = ["192.168.0.1" "45.90.28.195" "8.8.8.8" "8.8.4.4"];

    hostId = "8425e349";
    hostName = "thelio_mega";

    hosts = {
      # for docker, letting it pull over ipv4. ipv6 isn't working for some
      # reason
      "23.22.106.255" = ["registry-1.docker.io"];
    };
  };

  environment.systemPackages = [
    pkgs.coreutils
    pkgs.ntfs3g
    pkgs.polymc
    pkgs.util-linux
    pkgs.nftables
    pkgs.nvme-cli
    pkgs.smartmontools
    pkgs.efibootmgr
    pkgs.pciutils
    pkgs.iotop
  ];

  users = {
    mutableUsers = false;

    users.root = {
      openssh.authorizedKeys.keys = import ./chessai-ssh-keys.nix;
      hashedPassword = "$6$Dyx8c0/AKrDLP/ct$f.CJ6tp4DYGZvDpgH1ffbiIXYvrFM0/Czs41vP5MfJKywNYGtAGZvHaTWbBB/L6DrLVgpz7BTrIuLPWVkUDkE1";
    };

    users.chessai = {
      description = "chessai";
      isNormalUser = true;
      uid = 1000;
      createHome = true;
      home = "/home/chessai";
      extraGroups = [
        "adbusers"
        "audio"
        "docker"
        "libvirtd"
        "networkmanager"
        "plugdev"
        "sway"
        "users"
        "vboxusers"
        "video"
        "wheel"
        "wireshark"
      ];
      hashedPassword = "$6$wA4C5Rij.J4xZHMn$cJjyAXP9KYpmAgRfTKooL5lKYtPvQ0DwErev4loNEIwka/pNjpJiPjU0XYI9ePUwWHzw.POPguYs56Ptm26Do0";
      openssh.authorizedKeys.keys = import ./chessai-ssh-keys.nix;
    };

    #users.zk = {
    #  description = "zk proof user";
    #  isNormalUser = true;
    #  uid = 2555;
    #  createHome = true;
    #  home = "/home/zk";
    #  extraGroups = [];
    #  #hashedPassword = "";
    #  #openssh.authorizedKeys.keys = [];
    #};
  };

  services.zfs = {
    autoSnapshot.enable = true;
  };

  services.avahi.enable = true;

  systemd.coredump.enable = true;

  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
    autoPrune.enable = true;
    daemon.settings = {
      ipv6 = false;
    };
  };

  virtualisation.virtualbox = {
    host = {
      enable = true;
    };

    guest = {
      enable = true;
      dragAndDrop = true;
    };
  };
  users.extraGroups.vboxusers.members = [ "chessai" ];

  nix = {
    nixPath = [ "nixpkgs=${pkgs.path}" ];

    gc.automatic = false;
  };

  nix.settings = {
    trusted-users = [ "chessai" "root" ];

    cores = 16;

    substituters = [
      # NixOS.org
      "https://cache.nixos.org"

      # clever
      # "http://cache.earthtools.ca"

      # IOG
      #"https://cache.iog.io"

      # IOG-associated?
      #"https://cache.zw3rk.com"

      # Kadena
      #"https://nixcache.chainweb.com"
    ];

    trusted-public-keys = [
      # IOG
      #"hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      #"iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="

      # IOG-associated?
      #"loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk="

      # clever
      # "c2d.localnet-1:YTVKcy9ZO3tqPNxRqeYEYxSpUH5C8ykZ9ImUKuugf4c="

      # Kadena
      #"nixcache.chainweb.com:FVN503ABX9F8x8K0ptnc99XEz5SaA4Sks6kNcZn2pBY="
    ];
  };

  nix.extraOptions = lib.mkOrder 1 ''
    keep-outputs = true
    keep-derivations = true
    auto-optimise-store = false
    experimental-features = nix-command flakes ca-derivations recursive-nix
  '';

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
      permittedInsecurePackages = [];
    };

    overlays = [];
  };

  time = {
    timeZone = "America/Chicago";
    hardwareClockInLocalTime = false;
  };

  services.dbus.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.polkit.enable = true;

  # screen sharing section
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };
  # end screen sharing section

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      font-awesome
      freefont_ttf
      liberation_ttf_v2
      lmodern
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-extra
      powerline-fonts
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    /*
    error: nerdfonts has been separated into individual font packages under the namespace nerd-fonts.
       For example change:
         fonts.packages = [
           ...
           (pkgs.nerdfonts.override { fonts = [ "0xproto" "DroidSansMono" ]; })
         ]
       to
         fonts.packages = [
           ...
           pkgs.nerd-fonts._0xproto
           pkgs.nerd-fonts.droid-sans-mono
         ]
       or for all fonts
         fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
    */
    #fontconfig.defaultFonts = {
    #  serif = [ "Noto Serif" "Source Han Serif" ];
    #  sansSerif = [ "Noto Sans" "Source Han Sans" ];
    #};
  };

  services.hoogle = {
    port = config.services.hoogle.port.default;
    packages = hp: [ pkgs.chainweb-node ];
  };

  services.blueman.enable = true;
  hardware = {
    bluetooth = {
      enable = true;
      disabledPlugins = [];
      settings = {
        General = {
          ControllerMode = "bredr";
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    #pulseaudio = {
    #  enable = true;
    #  support32Bit = true;
    #  package = pkgs.pulseaudioFull;
    #  daemon.config = {
    #    # default-sample-rate = 48 * 1000;
    #  };
    #};
  };

  system.stateVersion = "23.05";

  services.chainweb-node = {
    enable = false;
    logLevel = "info";
    headerStream = true;
    bootstrapReachability = 0;
    #subdir = "mainnet01-sigma-compacted";
    configFile = ./chainweb-node-config.yaml;
    #replay = true;
  };

  ### section plex
  services.plex = {
    enable = true;
    openFirewall = true;

    user = "plex";
    group = "plex";

    dataDir = "/var/lib/plex";
  };

  users.users.plex.extraGroups = [ "users" "video" "render" ];

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

  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = builtins.toString (10 * 1000 * 1000);
    }
  ];

  programs.java.enable = true;
  programs.steam = {
    enable = true;
    #package = pkgs.steam.override { withJava = true; };
  };

  fileSystems."/mnt/data" =
    { device = "/dev/disk/by-uuid/5a899c16-a86c-4671-b39c-f31eaea40d82";
      fsType = "ext4";
    };

  # no metadata write on reads
  fileSystems."/nix/store".options = [ "noatime" ];
}
