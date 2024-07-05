{ pkgs, ... }:

{

  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; with pkgs.vscode-utils; [
      vscodevim.vim
      github.copilot-chat
      github.copilot
      mkhl.direnv
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      jnoortheen.nix-ide
      justusadam.language-haskell
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "alloglot";
        publisher = "friedbrice";
        version = "2.3.0";
        sha256 = "sha256-Z0izTBG4sx1xXA0wrqCvOE3u0BOCnJB2svkHHHsAJS0=";
      }
      {
        name = "haskell-ghcid";
        publisher = "ndmitchell";
        version = "0.3.1";
        sha256 = "sha256-Ke7P8EJ3ghYG1qyf+w8c2xJlGrRGkJgJwvt0MSb9O+Y=";
      }
    ];
    userSettings = builtins.fromJSON (builtins.readFile ./vscode-settings.json);
  };
}
