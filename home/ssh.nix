{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host athena
        User chessai
        Port 2202
        HostName newartisans.hopto.org

      Host analytics
        User root
        Hostname ec2-52-54-218-125.compute-1.amazonaws.com
    '';
  };
}
