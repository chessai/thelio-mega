{ ... }:

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
      ./colorscheme.nix
      ./packages.nix

      ./browsers/chromium.nix
      ./browsers/firefox.nix

      ./desktop

      ./dev/claude.nix
      ./dev/codex.nix
      ./dev/direnv.nix
      ./dev/git.nix
      ./dev/maestro.nix
      ./dev/ssh.nix
      ./dev/vscode.nix

      ./shell/alacritty.nix
      ./shell/bash.nix
      ./shell/jq.nix
      ./shell/tmux.nix
    ];

    home.stateVersion = "23.05";
  };
}
