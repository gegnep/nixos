{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf (config.mySystem.hardware.gpu == "intel") {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
  ];
}
