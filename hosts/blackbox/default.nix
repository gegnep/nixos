{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  # Host identity
  networking.hostName = "blackbox";
  system.stateVersion = "25.05";

  # Host options
  mySystem = {
    desktop = {
      wms = [
        "hyprland"
        "niri"
      ];
      monitors = [
        {
          name = "DP-3";
          width = 2560;
          height = 1440;
          refresh = 170.001;
          x = 0;
          y = 0;
          vrr = true;
          primary = true;
        }
        {
          name = "HDMI-A-1";
          width = 1920;
          height = 1080;
          refresh = 100.0;
          x = -1920;
          y = 0;
        }
      ];
    };
    hardware = {
      gpu = "amd";
      peripherals.wooting = true;
    };
    features = {
      gaming = true;
      streaming = true;
      audioProduction = true;
      mcsr = true;
    };
  };
}
