{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.spicetify-nix.homeManagerModules.spicetify

    ./packages.nix
    ./shell
    ./programs
    ./desktop
  ];

  home = {
    username = "pengeg";
    homeDirectory = "/home/pengeg";
    stateVersion = "25.05";
  };

  services.syncthing.enable = true;
}
