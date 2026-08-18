{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; with pkgs.vscode-utils; [
        vscodevim.vim
        #github.copilot-chat
        #github.copilot
        mkhl.direnv
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        jnoortheen.nix-ide
        justusadam.language-haskell
        oderwat.indent-rainbow
        ms-vscode.cpptools
        ms-vscode.hexeditor
        waderyan.gitblame
        timonwong.shellcheck
        mhutchie.git-graph
        rust-lang.rust-analyzer
        arrterian.nix-env-selector
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        #{
        #  name = "alloglot";
        #  publisher = "friedbrice";
        #  version = "2.3.0";
        #  sha256 = "sha256-Z0izTBG4sx1xXA0wrqCvOE3u0BOCnJB2svkHHHsAJS0=";
        #}
        {
          name = "regex";
          publisher = "chrmarti";
          version = "0.4.0";
          sha256 = "sha256-1yCTbDSIApgH7Fo9z8Kxlq6KdpuFQDl6LVHxEh/nNU8=";
        }
        {
          name = "vscode-augment";
          publisher = "augment";
          version = "0.708.0";
          sha256 = "sha256-ftNXkhjVAFYF2nOu8GEvawNZy2M/uPwWfugDd9RD6lQ=";
        }
      ];
      userSettings = builtins.fromJSON (builtins.readFile ./vscode-settings.json);
    };
  };
}
