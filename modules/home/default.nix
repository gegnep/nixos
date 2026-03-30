{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.nvf.homeManagerModules.default

    ./packages.nix
    ./desktop
    ./programs
    ./shell
  ];

  home = {
    username = "pengeg";
    homeDirectory = "/home/pengeg";
    stateVersion = "25.05";
  };

  services.syncthing.enable = true;
}
