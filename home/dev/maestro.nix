{ pkgs, ... }:

{
  # The maestro advisor-orchestration daemon as a systemd --user service
  # (module from the maestro flake, wired in via `home-manager.sharedModules`).
  #
  # Auto-restart on update: because the unit's ExecStart points at the maestro
  # package and the module sets `X-Restart-Triggers`, a `nixos-rebuild switch`
  # after `nix flake update maestro` restarts the daemon on the new binary
  # (home-manager's sd-switch, which release-26.05 enables by default). That
  # restart SIGTERMs the running daemon and interrupts whatever tasks it is
  # driving; they are journaled and come back re-runnable, but in-flight work is
  # cut short. Set `restartIfChanged = false` here to decouple upgrades from
  # restarts and restart by hand instead.
  services.maestro = {
    enable = true;

    # A systemd --user unit starts with a minimal PATH, but the daemon shells
    # out to git (worktree lifecycle) and bwrap (containment), drives the
    # `claude` CLI for worker/verifier phases, and runs project `check_commands`
    # that call `nix develop` (e.g. komugi's `nix develop -c bash ci/check.sh`).
    # Name every such tool explicitly; do not rely on the login PATH.
    path = with pkgs; [
      git
      bubblewrap
      nix
      bash
      coreutils
      claude-code
    ];
  };
}
