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
        description = "Window managers/compositors to enable on this host";
      };
      monitors = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                description = "Output name (DP-3, HDMI-A-1, eDP-1, etc.)";
              };
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
                description = "Designates primary monitor (used by noctalia and steam)";
              };
            };
          }
        );
        default = [ ];
        description = "Monitor layout for this host";
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
        description = "Which GPU stack to enable";
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
