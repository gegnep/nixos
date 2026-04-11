{ lib, ... }:

{
  options.mySystem.desktop = {
    wms = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "hyprland"
          "niri"
        ]
      );
      default = [ "hyprland" ];
      description = "Window managers/Compositors to enable on this machine";
    };
    defaultWm = lib.mkOption {
      type = lib.types.enum [
        "hyprland"
        "niri"
      ];
      default = "hyprland";
      description = "Which WM to autolaunch on tty2";
    };
  };
}
