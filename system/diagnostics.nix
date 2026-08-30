{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Hardware introspection
    dmidecode
    hwloc # lstopo
    lshw
    pciutils # lspci, setpci
    usbutils # lsusb

    # Storage & filesystem
    fio
    gptfdisk # sgdisk
    iotop
    lvm2 # lvscan, lvs, vgs
    ncdu
    nvme-cli
    parted
    smartmontools
    xfsprogs # mkfs.xfs, xfs_repair

    # CPU / memory / system perf
    bpftrace
    htop
    numactl
    perf
    sysstat

    # GPU
    nvtopPackages.full

    # Process tracing & debugging
    bcc
    # pre-canned eBPF utilities (biolatency, tcpconnect, ...
    # ...execsnoop, opensnoop, cachestat, ...)
    binutils # strings, readelf, objdump, nm - inspect unknown blobs
    file
    gdb
    lsof
    ltrace
    psmisc # pstree, fuser, killall - "what's holding this mount busy?"
    strace

    # Networking - observability
    bind.dnsutils # dig, host, nslookup
    ethtool
    iperf3
    iproute2 # ip, ss, tc
    iputils # ping, arping, tracepath
    mtr
    netcat-gnu # nc
    socat
    tcpdump
    traceroute

    # Networking - control / filter
    conntrack-tools
    ipset
    iptables
    nftables # nft

    # Text / data wrangling
    jq
    nano
    pv
    tree
    yq-go # yq (Go port; handles YAML/JSON/XML)

    # Multiplexers (TODO: look into better options)
    tmux

    # UEFI
    efibooteditor
    efibootmgr
    efitools
    efivar

    # Server Management
    ipmitool
    ipmiutil

    # General
    coreutils
    # b2sum base32 base64 basename basenc cat chcon chgrp chmod chown
    # chroot cksum comm coreutils cp csplit cut date dd df dir
    # dircolors dirname du echo env expand expr factor false fmt fold
    # groups head hostid id install join kill link ln logname ls
    # md5sum mkdir mkfifo mknod mktemp mv nice nl nohup nproc numfmt
    # od paste pathchk pinky pr printenv printf ptx pwd readlink
    # realpath rm rmdir runcon seq sha1sum sha224sum sha256sum
    # sha384sum sha512sum shred shuf sleep sort split stat stdbuf
    # stty sum sync tac tail tee test timeout touch tr true truncate
    # tsort tty uname unexpand uniq unlink uptime users vdir wc who
    # whoami yes
    util-linux
    # addpart agetty bits blkdiscard blkid blkpr blkzone blockdev cal
    # cfdisk chcpu chfn chmem choom chrt chsh col colcrt colrm column
    # copyfilerange coresched ctrlaltdel delpart dmesg eject enosys
    # exch fadvise fallocate fdisk fincore findfs findmnt flock fsck
    # fsck.cramfs fsck.minix fsfreeze fstrim getino getopt hardlink
    # hd hexdump hwclock i386 ionice ipcmk ipcrm ipcs irqtop isosize
    # kill last lastb lastlog2 ldattach linux32 linux64 logger login
    # look losetup lsblk lsclocks lscpu lsfd lsipc lsirq lslocks
    # lslogins lsmem lsns mcookie mesg mkfs mkfs.bfs mkfs.cramfs
    # mkfs.minix mkswap more mount mountpoint namei nologin nsenter
    # partx pipesz pivot_root prlimit readprofile rename renice
    # resizepart rev rfkill rtcwake runuser script scriptlive
    # scriptreplay setarch setpgid setpriv setsid setterm sfdisk
    # sulogin swaplabel swapoff swapon switch_root taskset uclampset
    # ul umount uname26 unshare utmpdump uuidd uuidgen uuidparse
    # waitpid wall wdctl whereis wipefs write x86_64 zramctl
  ];

  systemd.coredump.enable = true;
}
