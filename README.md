# thelio-mega

The NixOS configuration for a single machine: `thelio-mega`, a System76 Thelio
(x86_64-linux, AMD CPU, ZFS root, sway/Wayland desktop, Plex server, Docker and
VirtualBox host). The flake also builds a minimal installer image as the `iso`
configuration.

There is no multi-host abstraction here on purpose — this repo describes one
computer.

## Commands

Rebuild and activate:

```
sudo nixos-rebuild switch --flake .#thelio-mega
```

The `#thelio-mega` is optional.

Build without switching:

```
nixos-rebuild build --flake .#thelio-mega
# or, without nixos-rebuild:
nix build .#nixosConfigurations.thelio-mega.config.system.build.toplevel
```

Check and format:

```
nix flake check              # builds checks.toplevel, checks.iso, checks.formatting
nix flake check --no-build   # evaluate only; much faster
nix fmt                      # nixfmt (RFC style) over every *.nix file, via treefmt
```

`checks.formatting` fails if the tree is not formatted, so `nix fmt` before
committing.

Build the installer ISO:

```
nix build .#nixosConfigurations.iso.config.system.build.isoImage
# result/iso/*.iso
```

Note that this flake reads only files that git knows about. After creating a
new file, `git add` it before evaluating anything, or Nix will not see it.

## Layout

```
flake.nix               inputs, the two nixosConfigurations, checks + formatter
flake.lock
disk-config.nix         disko: 1TB NVMe, GPT (ESP / zfs / 32G swap), the zroot
                        pool and its dataset split (/, /etc, /home, /var,
                        /nix, docker and coredumps unsnapshotted, 5GiB reserved)
chessai-ssh-keys.nix    the two authorised public keys, imported by both root
                        and chessai
iso.nix                 minimal installer image: installation-cd-minimal, sshd,
                        firewall, root's ed25519 key

system/
  default.nix           imports everything below, plus not-detected.nix,
                        qemu-guest.nix, ../disk-config.nix and ../home;
                        system.stateVersion = "23.05"
  boot.nix              GRUB/EFI (nodev, efiInstallAsRemovable, EFI vars not
                        touched), initrd modules, kvm-amd, ZFS devNodes and
                        forceImport settings, tmpfs /tmp
  storage.nix           smartd, rasdaemon, ZFS autoScrub + autoSnapshot, the
                        /mnt/data mount, noatime on /nix/store
  networking.nix        sshd, NetworkManager, firewall, the DNS workaround,
                        hostId/hostName, the docker registry hosts entry, avahi
  users.nix             mutableUsers = false; root and chessai (uid 1000,
                        hashed passwords, group memberships); nofile ulimit
                        raised to 10,000,000
  nix.nix               nixPath, gc disabled, trusted-users, cores = 16,
                        substituters (cache.nixos.org, nix-community),
                        experimental-features, allowUnfree, America/Chicago
  virtualisation.nix    Docker on the zfs storage driver with IPv6 off and
                        autoPrune; VirtualBox host
  desktop.nix           dbus, sway, polkit, pipewire, xdg-desktop-portal
                        (wlr + gtk), fonts including all of nerd-fonts, Java,
                        Steam, nix-ld
  diagnostics.nix       a large environment.systemPackages of hardware,
                        storage, perf, network, tracing and UEFI tools;
                        systemd coredumps
  hardware/nvidia.nix   RTX 50-series (Blackwell) open kernel modules for CUDA
                        compute on a headless box, coexisting with the AMD
                        W6400. services.xserver.videoDrivers is only how the
                        NixOS nvidia module gets activated; it does not start X
  hardware/bluetooth.nix  blueman and bluez, ControllerMode = bredr
  services/plex.nix     Plex (openFirewall, dataDir /var/lib/plex, plex user in
                        video/render) plus the fix-media-permissions oneshot
                        that chgrps /mnt/data/media to video and adds g+w

home/                   home-manager, imported by system/default.nix as a NixOS
                        module (so it activates with nixos-rebuild, not
                        separately)
  default.nix           useGlobalPkgs / useUserPackages, the chessai user, the
                        import list, home.stateVersion = "23.05", manpages off
  colorscheme.nix       the `colorscheme` module: a `palette` option holding
                        eight seed colours as hex, and a read-only `colors`
                        option holding the parsed values, the role names
                        (primary/secondary/accent/dark/light, each with light
                        and dark variants) and the render helpers
  packages.nix          the user package list (see mkAfter, below)
  browsers/chromium.nix programs.chromium.enable
  browsers/firefox.nix  placeholder; firefox is commented out
  desktop/default.nix   sets the swayfont and modifier module args shared by
                        the desktop modules, then imports them
  desktop/sway.nix      sway: fonts, gaps, caps:swapescape, colours from the
                        colorscheme, keybindings (Mod4), no bars
  desktop/waybar.nix    the top bar - workspaces, mode, window title, network,
                        clock - plus its CSS
  desktop/mako.nix      notification daemon, colours from the colorscheme
  desktop/rofi.nix      programs.rofi.enable
  desktop/swaylock.nix  lock screen appearance (blur, vignette, ring colours)
  desktop/swayidle.nix  lock at 5 minutes, displays off at 10
  desktop/session.nix   xdg.configFile texts: environment.d session variables
                        (MOZ_ENABLE_WAYLAND, XDG_CURRENT_DESKTOP, ...) and the
                        networkmanager-dmenu config
  dev/git.nix           the ignores list, user/email, pull.rebase, LFS,
                        push.autoSetupRemote, init.defaultBranch = main
  dev/ssh.nix           ssh client config with enableDefaultConfig = false, so
                        the departing implicit defaults stay explicit; keepalives
                        for github.com
  dev/direnv.nix        direnv + nix-direnv
  dev/vscode.nix        VS Code, with a helper that forces marketplace
                        extensions to arch linux-x64 (several default to macOS)
  dev/claude.nix        the claude-code package and .claude/settings.json,
                        including the Bash permission allow/deny lists
  shell/bash.nix        history settings, aliases (eza, bat, ripgrep, git),
                        vi mode, EDITOR=nvim, starship init
  shell/alacritty.nix   alacritty, colours from the colorscheme, font size 18
  shell/tmux.nix        programs.tmux.enable
  shell/jq.nix          programs.jq.enable

lib/
  colors.nix            generic colour maths only: hex <-> rgb <-> hsv, floor/
                        round/clamp, brighten/darken. No palette lives here

overlays/
  default.nix           the overlay list: one overlay, exposing maestro from
                        its flake as pkgs.maestro
```

Neovim is not in `home/packages.nix`. It is injected by an inline module in
`flake.nix`, from the `nvim-configs` input.

Neovim is 0.12.4. The plugin set in `nvim-configs`' `lazy-lock.json` is managed by
lazy.nvim outside Nix, so it is updated with `:Lazy update`, not by a rebuild.

## Machine-specific magic values

Things that are non-obvious and are dangerous to change without knowing why
they are what they are.

**`networking.hostId = "8425e349"`** (`system/networking.nix`). ZFS stamps the
host id onto a pool when it imports it, and refuses to auto-import a pool last
touched by a different host id. NixOS requires the option to be set when the
root filesystem is ZFS, and `boot.zfs.forceImportRoot` is `false` here, so
nothing will paper over a mismatch: change this value and `zroot` will not
import, which means the machine will not boot.

**`/mnt/data` UUID `5a899c16-a86c-4671-b39c-f31eaea40d82`**
(`system/storage.nix`). A separate ext4 disk, not part of the `zroot` pool
described in `disk-config.nix`, mounted by UUID rather than device name so
enumeration order cannot move it. `/mnt/data/media` is what Plex serves and
what the `fix-media-permissions` unit chgrps, so both break if this mount is
wrong.

**The DNS settings** (`system/networking.nix`: `nameservers`,
`resolvconf.dnsExtensionMechanism = false`, `networkmanager.dns = "none"`).
This is a workaround for the router at 192.168.0.1, not a preference. The
comment above the option explains the failure mode; read it before touching any
of the three, since they only work as a set.

**`networking.enableIPv6 = false`** and the `hosts` entry pinning
`registry-1.docker.io` to `23.22.106.255` (`system/networking.nix`), together
with `virtualisation.docker.daemon.settings.ipv6 = false`
(`system/virtualisation.nix`). IPv6 on this network is broken; Docker would
otherwise try the registry over IPv6 and hang rather than fall back. The pinned
address is a hardcoded IPv4 for a load-balanced host, so it can go stale — if
`docker pull` starts failing, suspect this line first.

**`lib.mkAfter` in `home/packages.nix`.** It is load-bearing, not decoration.
home-manager's own program modules each contribute to `home.packages`, and the
resulting list order is visible in the derivation, via the `paths` argument to
`buildEnv`. `mkAfter` reproduces the order the list had when it lived in the
body of `home/default.nix`, which is what keeps the profile derivation
identical across the reorganisation. Removing it rebuilds the user profile for
no reason.

## Known issues / follow-ups

- Two evaluation warnings are expected and harmless: `'system' has been renamed
  to/replaced by 'stdenv.hostPlatform.system'` from an input, and a
  `boot.zfs.forceImportRoot` default-value warning from the `iso`
  configuration, which does not set it.
