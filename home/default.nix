{ pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users.chessai = {
    # this just uses global pkgs settings
    # if useGlobalPkgs is set
    #nixpkgs.config = {
    #  allowUnfree = true;
    #  allowBroken = false;
    #};

    # Fails to build often and idc about it
    manual.manpages.enable = false;

    imports = [
      ./alacritty.nix
      ./bash.nix
      ./chromium.nix
      ./direnv.nix
      ./firefox.nix
      ./git.nix
      ./jq.nix
      ./ssh.nix
      ./tmux.nix
      ./vscode.nix
      ./wayland.nix
    ];

    home.packages = with pkgs; [
      (aspellWithDicts (d: [ d.en ]))
      awscli2
      bind
      bluetuith
      cabal-install
      cachix
      claude-code
      cockatrice
      discord
      edopro
      fd
      file
      findutils
      ghcid
      ghciwatch
      gist
      gnumake
      grim # wayland screenshot application that works
      htop
      imv # wayland image viewer that works
      kooha
      #libnotify
      #perf #linuxKernel.packages.linux_5_15.perf
      qbittorrent
      mosh
      networkmanager_dmenu
      networkmanagerapplet
      nix-prefetch-git
      nmap
      parallel
      parted
      pavucontrol
      pdfpc # pdf presentation viewer run with -s -S
      pinentry-gnome3
      ripgrep
      rofi
      signal-desktop
      silver-searcher
      slack
      slurp
      spotify
      swaylock-effects
      tcpdump
      telegram-desktop
      tldr
      tmux
      tree
      w3m
      waybar
      wget
      which
      wl-clipboard
      xorriso
      xwayland
      xxd
      yt-dlp
    ];

    home.stateVersion = "23.05";
  };

  /*
  home-manager.users.zk = {
    nixpkgs.config = {
      allowUnfree = true;
      allowBroken = false;
    };

    # Fails to build often and idc about it
    manual.manpages.enable = false;

    imports = [
      ./jq.nix
    ];

    home.packages = with pkgs; [
      fd
      file
      findutils
      gnumake
      htop
      linuxKernel.packages.linux_5_15.perf
      parallel
      silver-searcher
      tldr
      which
      xxd
    ];

    home.stateVersion = "23.05";
  };
  */
}
