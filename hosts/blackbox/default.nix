{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  # Host identity
  networking.hostName = "blackbox";
  system.stateVersion = "25.05";

  # WM options
  mySystem.desktop.wms = [ "hyprland" ];
  mySystem.desktop.defaultWm = "hyprland";
}
