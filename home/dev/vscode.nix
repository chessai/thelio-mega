{ pkgs, ... }:

let
  # some extensions for some reason default to MacOS even when the system
  # is Linux
  vscodeLinuxExt =
    args@{
      name,
      publisher,
      version,
      sha256,
      ...
    }:
    pkgs.vscode-utils.extensionFromVscodeMarketplace (
      args
      // {
        arch = "linux-x64";
      }
    );
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
          commandsToSkipShell = [ ];
        };

        claudeCode = {
          preferredLocation = "sidebar";
          selectedModel = "claude-fable-5-1";
          environmentVariables = [ ];
          disableLoginPrompt = false;
          allowDangerouslySkipPermissions = true;
        };

        chatgpt = {
          commentCodeLensEnabled = true;
          openOnStartup = false;
          followUpQueueMode = "steer";
          composerEnterBehavior = "enter";
          reviewDelivery = "inline";
        };
      };

      extensions =
        with pkgs.vscode-extensions;
        with pkgs.vscode-utils;
        [
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
        ]
        ++ builtins.map vscodeLinuxExt [
          {
            name = "claude-code";
            publisher = "anthropic";
            version = "2.1.258";
            sha256 = "sha256-eIJB3cp3HeD5DGcr/mp4kjkY/gMFp9oam8cGKeKSOMc=";
          }

          {
            name = "chatgpt";
            publisher = "openai";
            version = "26.5825.51511";
            sha256 = "sha256-VX6AWYCWR4k79fyG+6FRVSjBYRr+MdVieSZsL83iogQ=";
          }
        ];
    };
  };
}
