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
  # Avaliable: hyprland, niri
  mySystem.desktop.wms = [
    "hyprland"
    "niri"
  ];
}
