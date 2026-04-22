{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.niri.nixosModules.niri
    inputs.nirinit.nixosModules.nirinit
  ];

  config = lib.mkIf (builtins.elem "niri" config.mySystem.desktop.wms) {
    niri-flake.cache.enable = true;
    programs.niri = {
      enable = true;
      package = pkgs.niri-stable; # use niri pkg from flake as its updated quicker
    };
    environment.systemPackages = with pkgs; [ xwayland-satellite ];

    services.nirinit = {
      enable = true;
      settings = {
        skip.apps = [ ];
        launch = { };
      };
    };
  };
}
