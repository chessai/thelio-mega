{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host athena
        User chessai
        Port 22
        HostName 67.181.169.43
    '';
  };
}
