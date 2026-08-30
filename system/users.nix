{ ... }:

{
  users = {
    mutableUsers = false;

    users.root = {
      openssh.authorizedKeys.keys = import ../chessai-ssh-keys.nix;
      hashedPassword = "$6$Dyx8c0/AKrDLP/ct$f.CJ6tp4DYGZvDpgH1ffbiIXYvrFM0/Czs41vP5MfJKywNYGtAGZvHaTWbBB/L6DrLVgpz7BTrIuLPWVkUDkE1";
    };

    users.chessai = {
      description = "chessai";
      isNormalUser = true;
      uid = 1000;
      createHome = true;
      home = "/home/chessai";
      extraGroups = [
        "adbusers"
        "audio"
        "docker"
        "libvirtd"
        "networkmanager"
        "plugdev"
        "sway"
        "users"
        "vboxusers"
        "video"
        "wheel"
        "wireshark"
      ];
      hashedPassword = "$6$wA4C5Rij.J4xZHMn$cJjyAXP9KYpmAgRfTKooL5lKYtPvQ0DwErev4loNEIwka/pNjpJiPjU0XYI9ePUwWHzw.POPguYs56Ptm26Do0";
      openssh.authorizedKeys.keys = import ../chessai-ssh-keys.nix;
    };

  };

  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = builtins.toString (10 * 1000 * 1000);
    }
  ];
}
