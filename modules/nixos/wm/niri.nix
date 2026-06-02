{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

let
  niriPkgs = inputs.niri-pkgs.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    inputs.nirinit.nixosModules.nirinit
  ];

  config = lib.mkIf (builtins.elem "niri" config.mySystem.desktop.wms) {
    programs.niri = {
      enable = true;
      package = niriPkgs.niri-unstable;
    };

    environment.systemPackages = [ niriPkgs.xwayland-satellite-unstable ];

    services.nirinit = {
      enable = true;
      settings = {
        skip.apps = [ ];
        launch = { };
      };
    };
  };
}
