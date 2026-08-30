{ lib, ... }:

{
  programs.ssh = {
    enable = true;

    # The old implicit defaults are going away; keep them explicitly.
    enableDefaultConfig = false;

    settings = {
      "github.com" = lib.hm.dag.entryBefore [ "*" ] {
        ServerAliveInterval = 60;
        ServerAliveCountMax = 10;

        # needed for git lfs
        # git config core.sshCommand "ssh -o 'ServerAliveInterval=60' -o 'ServerAliveCountMax=10' -o 'ControlMaster=auto' -o 'ControlPath=~/.ssh/control-%C' -o 'ControlPersist=600'"
      };

      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
    };
  };
}
