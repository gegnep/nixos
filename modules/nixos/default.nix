{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware

    ./boot.nix
    ./desktop.nix
    ./networking.nix
    ./nix.nix
    ./options.nix
    ./performance.nix
    ./programs.nix
    ./users.nix
    ./secrets.nix

    ./wm/hyprland.nix
    ./wm/niri.nix
  ];
}
