{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf (builtins.elem "niri" config.mySystem.desktop.wms) {
    programs.niri.enable = true;
  };
}
