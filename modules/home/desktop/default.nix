{ lib, hostOptions, ... }:

{
  imports = [
    ./common
  ]
  ++ lib.optional (builtins.elem "niri" hostOptions.desktop.wms) ./wm/niri;
}
