{ lib, hostDesktop, ... }:

{
  imports = [
    ./common
  ]
  ++ lib.optional (builtins.elem "hyprland" hostDesktop.wms) ./wm/hyprland
  ++ lib.optional (builtins.elem "niri" hostDesktop.wms) ./wm/niri;
}
