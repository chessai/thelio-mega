{ ... }:

{
  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
    autoPrune.enable = true;
    daemon.settings = {
      ipv6 = false;
    };
  };

  virtualisation.virtualbox = {
    host = {
      enable = true;
    };
  };
  users.extraGroups.vboxusers.members = [ "chessai" ];
}
