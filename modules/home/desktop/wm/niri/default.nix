{
  config,
  lib,
  inputs,
  hostDesktop,
  ...
}:

{
  imports = [ inputs.niri.homeModules.niri ];

  programs.niri.settings = {

  };
}
