{ lib, hostOptions, ... }:

{
  imports = [
    ./common
  ]
  ++ lib.optional (builtins.elem "hyprland" hostOptions.desktop.wms) ./wm/hyprland
  ++ lib.optional (builtins.elem "niri" hostOptions.desktop.wms) ./wm/niri;
}
