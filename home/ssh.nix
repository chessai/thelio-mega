{ lib, ... }:

{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github.com" = lib.hm.dag.entryBefore ["*"] {
         serverAliveInterval = 60;
         serverAliveCountMax = 10;

         # needed for git lfs
         # git config core.sshCommand "ssh -o 'ServerAliveInterval=60' -o 'ServerAliveCountMax=10' -o 'ControlMaster=auto' -o 'ControlPath=~/.ssh/control-%C' -o 'ControlPersist=600'"
      };
    };

    extraConfig = ''
    '';
  };
}
