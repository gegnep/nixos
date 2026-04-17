{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "nixpad";
  system.stateVersion = "25.05";

  mySystem = {
    desktop = {
      wms = [ "niri" ];
      monitors = [
        {
          name = "e-DP-1";
          width = 1920;
          height = 1200;
          refresh = 60.02;
          scale = 1.0;
          primary = true;
        }
      ];
    };
    hardware = {
      form = "laptop";
      gpu = "intel";
      swapfile = {
        enable = true;
        sizeGB = 16;
      };
      peripherals.wooting = false;
    };
    features = {
      gaming = false;
      streaming = false;
      audioProduction = false;
      mcsr = false;
    };
  };
}
