{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../disk-config.nix
    ../home
    ./boot.nix
    ./storage.nix
    ./networking.nix
    ./users.nix
    ./nix.nix
    ./virtualisation.nix
    ./desktop.nix
    ./diagnostics.nix
    ./hardware/nvidia.nix
    ./hardware/bluetooth.nix
    ./services/plex.nix
  ];

  system.stateVersion = "23.05";
}
