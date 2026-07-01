{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf (config.mySystem.hardware.gpu == "amd") {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu = {
    opencl.enable = true;
    overdrive = {
      enable = true;
      ppfeaturemask = "0xfffd7fff";
    };
  };
  services.lact.enable = true;

  environment.systemPackages = with pkgs; [
    clinfo
    radeontop
  ];
}
