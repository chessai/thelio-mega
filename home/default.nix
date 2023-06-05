{ pkgs, lib, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users.chessai = {
    nixpkgs.config = {
      allowUnfree = true;
      allowBroken = false;
    };

    # Fails to build often and idc about it
    manual.manpages.enable = false;

    imports = [
      ./alacritty.nix
      ./bash.nix
      ./direnv.nix
      ./git.nix
      ./jq.nix
      ./ssh.nix
      ./tmux.nix
      ./vim.nix
      ./wayland.nix
    ];

    home.packages = with pkgs; [
      (aspellWithDicts (d: [ d.en ]))
      bind
      cabal-install
      discord
      fd
      file
      findutils
      ghcid
      gist
      gnumake
      grim # wayland screenshot application that works
      htop
      imv # wayland image viewer that works
      libnotify
      linuxKernel.packages.linux_5_15.perf
      mosh
      nix-prefetch-git
      nmap
      parallel
      parted
      pdfpc # pdf presentation viewer run with -s -S
      ripgrep
      rofi
      signal-desktop
      silver-searcher
      slurp
      spotify
      swaylock-effects
      tcpdump
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
      youtube-dl
    ];

    home.stateVersion = "23.05";
  };
}
