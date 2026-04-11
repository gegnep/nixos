{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./desktop.nix
    ./hardware.nix
    ./networking.nix
    ./nix.nix
    ./options.nix
    ./performance.nix
    ./programs.nix
    ./users.nix

    ./wm/hyprland.nix
    ./wm/niri.nix
  ];
}
