{ pkgs, ... }:

{
  services.openssh = {
    enable = true;
  };

  networking = {
    enableIPv6 = false; # something is wrong with my network, ipv6 keeps causing issues

    # use NetworkManager
    wireless.enable = true;
    networkmanager.enable = true; # use NetworkManager

    firewall = {
      enable = true;
      extraCommands = ''
        # Create OUTPUT chain if it doesn't exist, then add accept rule for all
        # outgoing traffic
        #${pkgs.nftables}/bin/nft add chain ip filter OUTPUT '{ type filter hook output priority 0; policy accept; }' 2>/dev/null || true
        #${pkgs.nftables}/bin/nft add chain ip6 filter OUTPUT '{ type filter hook output priority 0; policy accept; }' 2>/dev/null || true
      '';
    };

    # 192.168.0.1 (the router) returns malformed responses to EDNS0 queries,
    # which makes glibc getaddrinfo fail outright instead of trying the next
    # server. Skip it and turn EDNS0 off so a DHCP-supplied forwarder cannot
    # reintroduce the same failure.
    nameservers = [
      "45.90.28.195"
      "8.8.8.8"
      "8.8.4.4"
    ];
    resolvconf.dnsExtensionMechanism = false;
    networkmanager.dns = "none";

    # Can't change hostId, ZFS uses it
    hostId = "8425e349";
    hostName = "thelio-mega";

    hosts = {
      # for docker, letting it pull over ipv4. ipv6 isn't working for some
      # reason
      "23.22.106.255" = [ "registry-1.docker.io" ];
    };
  };

  services.avahi.enable = true;
}
