{ config, lib, pkgs, ... }:

let
  codexDir = "${config.home.homeDirectory}/.codex";

  prefixRules = decision: justification: prefixes:
    builtins.map (pattern: ''
      prefix_rule(
        pattern = ${builtins.toJSON pattern},
        decision = "${decision}",
        justification = "${justification}",
      )
    '') prefixes;

  forbiddenTerraformPrefixes = [
    [ "terraform" "apply" ]
    [ "terraform" "destroy" ]
  ];

  promptedPrefixes = [
    [ "git" "add" ]
    [ "git" "commit" ]
    [ "git" "fetch" ]
    [ "git" "push" ]
    [ "git" "reset" "--hard" ]
    [ "git" "clean" ]
    [ "git" "checkout" "--" ]
    [ "git" "restore" ]
    [ "git" "stash" ]
    [ "rm" "-rf" ]
    [ "sudo" ]
    [ "curl" ]
    [ "wget" ]
    [ "aws" ]
  ];

  allowedPrefixes = builtins.map (x: [x]) [
    "basename" "cat" "cut" "date" "df" "diff" "dirname" "du" "echo" "file"
    "grep" "head" "hostname" "jq" "ls" "printf" "pwd" "realpath" "sort" "stat"
    "tail" "tree" "type" "uname" "uniq" "wc" "which" "whoami"
  ] ++ [
    [ "git" "blame" ]
    [ "git" "branch" "--show-current" ]
    [ "git" "describe" ]
    [ "git" "diff" ]
    [ "git" "log" ]
    [ "git" "ls-files" ]
    [ "git" "ls-tree" ]
    [ "git" "remote" "-v" ]
    [ "git" "remote" "get-url" ]
    [ "git" "rev-list" ]
    [ "git" "rev-parse" ]
    [ "git" "shortlog" ]
    [ "git" "show" ]
    [ "git" "status" ]
    [ "git" "tag" "--list" ]
    [ "nix" "eval" ]
    [ "nix" "flake" "metadata" ]
    [ "nix" "flake" "show" ]
    [ "nix" "log" ]
    [ "nix" "path-info" ]
    [ "nix" "show-derivation" ]
    [ "nix-instantiate" ]
    [ "nix-store" "--query" ]
    [ "nix-store" "-q" ]
  ];
in
{
  home.packages = [ pkgs.codex ];

  home.file.".codex/config.toml".text = ''
    model = "gpt-5.6-sol"
    model_reasoning_effort = "high"
  '';

  home.file.".codex/rules/default.rules".text =
    builtins.concatStringsSep "\n" (
      (prefixRules "forbidden" "Direct Terraform applies and destroys are forbidden; use Terraform Cloud." forbiddenTerraformPrefixes)
      ++ (prefixRules "prompt" "Requires review to run" promptedPrefixes)
      ++ (prefixRules "allow" "Allowed by the managed Codex policy" allowedPrefixes)
    );
}
