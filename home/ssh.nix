{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host athena
        User chessai
        Port 2202
        HostName 76.234.69.149
    '';
  };
}
