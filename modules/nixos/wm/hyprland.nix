{ config, lib, ... }:

lib.mkIf (builtins.elem "hyprland" config.mySystem.desktop.wms) {
  programs.hyprland.enable = true;
}
