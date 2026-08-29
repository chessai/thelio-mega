let
  ignores = [
    # object files
    "*.a"
    "*.o"
    "*.so"

    # haskell stuff
    ".ghc.environment.*"
    "dist"
    "dist-*"
    "cabal-dev"
    "*.chi"
    "*.chs.h"
    "*.dyn_o"
    "*.dyn_hi"
    "*.prof"
    "*.hp"
    "*.eventlog"
    ".cabal-sandbox/"
    "cabal.sandbox.config"
    "cabal.config"
    "cabal.project.local"
    ".HTF/"
    ".stack-work/"
    "stack.yaml.lock"

    # vim stuff
    "[._]*.s[a-v][a-z]"
    "[._]*.sw[a-p]"
    "[._]s[a-v][a-z]"
    "[._]sw[a-p]"
    "*~"

    # nix stuff
    "result"
    "result-*"
    "*.hi"

    # make/latexmk stuff
    ".makefile"
    "*.aux"
    "*.fdb_latexmk"
    "*.fls"
    "*.log"
    "*.out"

    # misc
    "tags"
  ];
in
{
  programs.git = {
    enable = true;

    inherit ignores;

    lfs.enable = true;

    settings = {
      user = {
        name = "chessai";
        email = "chessai1996@gmail.com";
      };

      pull.rebase = true;

      # no more -u
      push.autoSetupRemote = true;

      init.defaultBranch = "main";
    };
  };
}
