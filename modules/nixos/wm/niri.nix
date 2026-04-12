{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.niri.nixosModules.niri ];

  config = lib.mkIf (builtins.elem "niri" config.mySystem.desktop.wms) {
    programs.niri = {
      enable = true;
      #package = pkgs.niri-unstable;
    };
    environment.systemPackages = [ pkgs.xwayland-satellite ];
  };
}
