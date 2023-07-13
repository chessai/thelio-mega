{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host athena
        User chessai
        Port 2202
        HostName newartisans.hopto.org
    '';
  };
}
