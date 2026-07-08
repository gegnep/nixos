{
  inputs,
  ...
}:

{
  imports = [
    ./desktop
    ./packages.nix
    ./programs
    ./shell

    inputs.catppuccin.homeModules.catppuccin
    inputs.nix-index-database.homeModules.nix-index
    inputs.noctalia.homeModules.default
    inputs.moonlight.homeModules.default

    inputs.nvf.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  home = {
    username = "pengeg";
    homeDirectory = "/home/pengeg";
    stateVersion = "25.05";
  };
}
