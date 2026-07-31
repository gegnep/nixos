{
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [
    inputs.nirinit.nixosModules.nirinit
  ];

  config = lib.mkIf (builtins.elem "niri" config.mySystem.desktop.wms) {
    programs.niri.enable = true;

    services.nirinit = {
      enable = true;
      settings = {
        skip.apps = [ ];
        launch = { };
      };
    };
  };
}
