{ pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;

    historySize = 10 * 1000;
    historyFileSize = 1000 * 1000;
    historyControl = [ "ignoredups" ];
    historyIgnore = [ "ls" "cd" "exit" "vi" "vim" "nvim" ];

    shellAliases = {
      ".0" = "cd .";
      ".1" = "cd ..";
      ".2" = "cd ../..";
      ".3" = "cd ../../..";
      ".4" = "cd ../../../..";
      ".5" = "cd ../../../../..";

      ls = "${pkgs.eza}/bin/eza -G --color auto -a -s type";
      ll = "${pkgs.eza}/bin/eza -l --color always -a -s type";
      cat = "${pkgs.bat}/bin/bat -pp --theme=\"Nord\"";
      grep = "${pkgs.ripgrep}/bin/rg";
      rg = "${pkgs.ripgrep}/bin/rg";

      git = "${pkgs.gitAndTools.gitFull}/bin/git";
      gs = "${pkgs.gitAndTools.gitFull}/bin/git status";
      gc = "${pkgs.gitAndTools.gitFull}/bin/git clone git@github.com:$1/$2";
      git-initial-commit = "${pkgs.gitAndTools.gitFull}/bin/git commit -m \"Creō ā nihilō\"";

      gist = "gist --private";
      gist-archive = "for repo in $(gist -l | awk '{ print $1 }'); do git clone $repo 2> /dev/null; done";
      git-commit-stats = "git log --author=\"$(git config user.name)\" --pretty=tformat: --numstat | awk '{inserted+=$1; deleted+=$2; delta+=$1-$2; ratio=deleted/inserted} END {printf \"Commit stats:\\n- Lines added (total)....  %s\\n- Lines deleted (total)..  %s\\n- Total lines (delta)....  %s\\n- Add./Del. ratio (1:n)..  1 : %s\\n\", inserted, deleted, delta, ratio }' -";
      npg-most-recent = "nix-prefetch-git $(git remote -v | awk '{print $2}') --rev $(git log | head -n 1 | awk '{print $2}') | jq 'with_entries(select([.key] | inside([\"rev\", \"sha256\"])))'";

      yarn = "yarn --ignore-engines";
      ts = "nix-shell -E 'let pkgs = import <nixpkgs> {}; in pkgs.mkShell { buildInputs = with pkgs; [ nodejs-13_x yarn nodePackages.typescript ]; }'";

      ":q" = "exit";

      "xdg-open" = "wslview";
    };

    # Only source this once.
    # if [ -n "$__HM_SESS_VARS_SOURCED" ]; then return; fi
    # export __HM_SESS_VARS_SOURCED=1

    initExtra = lib.mkBefore ''
      export GRAPHVIZ_DOT="${pkgs.graphviz}/bin/dot"
      export LC_CTYPE="en_US.UTF-8";
      export EDITOR="nvim";
      export VISUAL="nvim";
      export BROWSER="wslview";

      set -o vi

      # must be at the end
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
  };
}
