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
    ./performance.nix
    ./programs.nix
    ./users.nix
  ];
}
