# NVIDIA RTX 50-series (Blackwell) support for CUDA compute on thelio-mega.
#
# This machine is headless: setting services.xserver.videoDrivers is simply how
# the NixOS nvidia module gets activated (it installs the kernel modules and the
# userspace/CUDA libraries); it does not enable X.
#
# The existing AMD W6400 / amdgpu setup is untouched - both cards coexist.
{ config, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    # Blackwell (RTX 50-series) is only supported by the open kernel modules.
    open = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = false;
    # Blackwell requires driver >= 570, so track the latest packaged driver.
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
}
