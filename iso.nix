{ config, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtYg2w4rOFH4QC9ncXH/WfzhCKg2REdAIMYWXFN/7gw chessai1996@gmail.com"
  ];

  networking.firewall.enable = true;

  services.openssh.enable = true;
}
