{ lib, ... }:

{
  options.mySystem = {

    desktop = {
      wms = lib.mkOption {
        type = lib.types.listOf (
          lib.types.enum [
            "hyprland"
            "niri"
          ]
        );
        default = [ "niri" ];
      };
      monitors = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption { type = lib.types.str; };
              width = lib.mkOption { type = lib.types.int; };
              height = lib.mkOption { type = lib.types.int; };
              refresh = lib.mkOption {
                type = lib.types.float;
                default = 60.0;
              };
              x = lib.mkOption {
                type = lib.types.int;
                default = 0;
              };
              y = lib.mkOption {
                type = lib.types.int;
                default = 0;
              };
              scale = lib.mkOption {
                type = lib.types.float;
                default = 1.0;
              };
              vrr = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              primary = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
            };
          }
        );
        default = [ ];
      };
    };

    hardware = {
      gpu = lib.mkOption {
        type = lib.types.enum [
          "amd"
          "intel"
          "nvidia"
          "none"
        ];
        default = "none";
      };
      form = lib.mkOption {
        type = lib.types.enum [
          "desktop"
          "laptop"
        ];
        default = "desktop";
      };
      peripherals.wooting = lib.mkEnableOption "Wooting keyboard udev rules";
    };

    features = {
      gaming = lib.mkEnableOption "Steam, gamescope, Proton, etc.";
      streaming = lib.mkEnableOption "OBS + v4l2loopback";
      audioProduction = lib.mkEnableOption "Bitwig, yabridge, etc.";
      mcsr = lib.mkEnableOption "PrismLauncher + MCSR stuff";
    };
  };
}
