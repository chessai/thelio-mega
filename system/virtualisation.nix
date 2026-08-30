{ ... }:

{
  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
    autoPrune.enable = true;
    daemon.settings = {
      ipv6 = false;

      # pin the dataset instead of letting the zfs driver infer it from
      # whatever happens to be mounted at /var/lib/docker
      storage-opts = [ "zfs.fsname=zroot/data/var/lib/docker" ];

      # published ports go through iptables instead of a docker-proxy
      # process per port; faster, but it changes how those ports are
      # reached - host-to-published-port can behave differently
      userland-proxy = false;
    };
  };

  virtualisation.virtualbox = {
    host = {
      enable = true;
    };
  };
  users.extraGroups.vboxusers.members = [ "chessai" ];
}
