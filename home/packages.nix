{ pkgs, lib, ... }:

{
  # mkAfter pins this list after every home-manager program module's own
  # home.packages contribution, reproducing the definition order the list had
  # when it lived in the body of home/default.nix. That order is visible in
  # the drvPath, via buildEnv's `paths`, so it is load-bearing: dropping
  # mkAfter rebuilds the profile.
  home.packages = lib.mkAfter (
    with pkgs;
    [
      (aspellWithDicts (d: [ d.en ]))
      awscli2
      bind
      bluetuith
      bubblewrap
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
      maestro
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
    ]
  );
}
