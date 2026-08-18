{ pkgs, ... }:

let
  # some extensions for some reason default to MacOS even when the system
  # is Linux
  vscodeLinuxExt = args@{ name, publisher, version, sha256, ... }:
    pkgs.vscode-utils.extensionFromVscodeMarketplace (args // {
      arch = "linux-x64";
    });
in
{
  programs.vscode = {
    enable = true;

    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;

      userSettings = {
        editor = {
          fontSize = 20;
          inlineSuggest.enabled = false;
          lineNumbers = "relative";
        };

        workbench.editor = {
          enablePreviewFromQuickOpen = false;
          enablePreview = false;
        };

        files.trimTrailingWhitespace = true;
        trailing-spaces.trimOnSave = true;

        keyboard.dispatch = "keycode";

        extensions.autoUpdate = false;
        extensions.ignoreRecommendations = true;

        terminal.integrated = {
          sendKeybindingsToShell = true;
          commandsToSkipShell = [];
        };

        claudeCode = {
          preferredLocation = "sidebar";
          selectedModel = "claude-fable-5";
          environmentVariables = [];
          disableLoginPrompt = false;
          allowDangerouslySkipPermissions = true;
        };
      };

      extensions = with pkgs.vscode-extensions; with pkgs.vscode-utils; [
        arrterian.nix-env-selector
        bbenoist.nix
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        github.vscode-github-actions
        hashicorp.terraform
        jnoortheen.nix-ide
        justusadam.language-haskell
        mechatroner.rainbow-csv
        mhutchie.git-graph
        mkhl.direnv
        ms-python.python
        ms-vscode.cpptools
        ms-vscode.hexeditor
        oderwat.indent-rainbow
        #rust-lang.rust-analyzer
        timonwong.shellcheck
        vscodevim.vim
        waderyan.gitblame
      ] ++ builtins.map vscodeLinuxExt [
        {
          name = "claude-code";
          publisher = "anthropic";
          version = "2.1.234";
          sha256 = "sha256-8SakE2rooV1s7+vDSNFKGErsnGEpxFMuds2Zit1b9cw=";
        }
      ];
    };
  };
}
