{ config, pkgs, ... }:

let
  claudeDir = "/home/chessai/.claude";

  claudeBashCommand = cmd: "Bash(${cmd} :*)";

  claudeSettings = builtins.toJSON {
    includeCoAuthoredBy = false;
    autoUpdatesChannel = "stable";
    defaultMode = "auto";

    permissions = {
      deny = builtins.map claudeBashCommand [
        "git add"
        "git push"
        "git reset --hard"
        "git clean"
        "git checkout --"
        "git restore"
      ];

      allow = builtins.map claudeBashCommand [
        "basename"
        "cargo"
        "cat"
        "date"
        "df"
        "dirname"
        "du"
        "echo"
        "env"
        "file"
        "find"
        "git blame"
        "git branch"
        "git describe"
        "git diff"
        "git fetch"
        "git log"
        "git ls-files"
        "git ls-tree"
        "git remote"
        "git rev-list"
        "git rev-parse"
        "git shortlog"
        "git show"
        "git stash list"
        "git status"
        "git tag"
        "grep"
        "head"
        "hostname"
        "ls"
        "nix develop"
        "nix eval"
        "nix flake metadata"
        "nix flake show"
        "nix log"
        "nix path-info"
        "nix show-derivation"
        "nix-instantiate"
        "nix-store --query"
        "nix-store -q"
        "printf"
        "pwd"
        "realpath"
        "stat"
        "tail"
        "tree"
        "type"
        "uname"
        "wc"
        "which"
        "whoami"
      ];
    };
  };
in
{
  home.packages = [ pkgs.claude-code ];

  home.file.".claude/settings.json".text = claudeSettings;
}
