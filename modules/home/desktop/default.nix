{ lib, hostDesktop, ... }:

{
  imports = [
    ./common
  ]
  ++ lib.optional (builtins.elem "hyprland" hostDesktop.wms) ./wm/hyprland;
}
