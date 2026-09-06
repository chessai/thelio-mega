{ pkgs, lib, ... }:

{
  services.openssh = {
    enable = true;
  };

  networking = {
    enableIPv6 = false; # something is wrong with my network, ipv6 keeps causing issues

    # NetworkManager only. networking.wireless.enable started a second,
    # standalone wpa_supplicant fighting NetworkManager for the same card,
    # which showed up as 40ms..1200ms jitter to the router.
    networkmanager.enable = true;

    firewall = {
      enable = true;
      extraCommands = ''
        # Create OUTPUT chain if it doesn't exist, then add accept rule for all
        # outgoing traffic
        #${pkgs.nftables}/bin/nft add chain ip filter OUTPUT '{ type filter hook output priority 0; policy accept; }'
2>/dev/null || true
        #${pkgs.nftables}/bin/nft add chain ip6 filter OUTPUT '{ type filter hook output priority 0; policy accept; }'
2>/dev/null || true
      '';
    };

    # 192.168.0.1 (the router) returns malformed responses to EDNS0 queries.
    # dns = "none" keeps NetworkManager from handing the DHCP-supplied router
    # to systemd-resolved, so only the servers below are ever used.
    #
    # Google first: measured 87ms against NextDNS's 558ms from here.
    # NextDNS (45.90.28.195) is kept only as a fallback.
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];
    networkmanager.dns = lib.mkForce "none";

    # Can't change hostId, ZFS uses it
    hostId = "8425e349";
    hostName = "thelio-mega";

    hosts = {
      # for docker, letting it pull over ipv4. ipv6 isn't working for some
      # reason
      "23.22.106.255" = [ "registry-1.docker.io" ];
    };
  };

  # Local caching resolver. Repeat lookups are answered from cache, and a
  # dead server is skipped in milliseconds instead of glibc's 5s timeout.
  services.resolved = {
    enable = true;
    settings.Resolve = {
      FallbackDNS = [ "45.90.28.195" ];
      DNSSEC = "false";
    };
  };

  services.avahi.enable = true;
}
