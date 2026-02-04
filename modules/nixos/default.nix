{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./nix.nix
    ./users.nix
    ./desktop.nix
    ./programs.nix
    ./performance.nix
  ];
}
