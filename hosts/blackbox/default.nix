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

  # Host options
  mySystem = {
    desktop.wms = [
      "hyprland"
      "niri"
    ];
    hardware = {
      gpu = "amd";
      peripherals.wooting = true;
    };
  };
}
