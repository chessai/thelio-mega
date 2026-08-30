{ ... }:

{
  services.blueman.enable = true;
  hardware = {
    bluetooth = {
      enable = true;
      disabledPlugins = [ ];
      settings = {
        General = {
          ControllerMode = "bredr";
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    #pulseaudio = {
    #  enable = true;
    #  support32Bit = true;
    #  package = pkgs.pulseaudioFull;
    #  daemon.config = {
    #    # default-sample-rate = 48 * 1000;
    #  };
    #};
  };
}
