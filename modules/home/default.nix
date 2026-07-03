{
  inputs,
  ...
}:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.noctalia.homeModules.default
    inputs.nvf.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.nix-index-database.homeModules.nix-index

    ./desktop
    ./programs
    ./shell

    ./packages.nix
  ];

  home = {
    username = "pengeg";
    homeDirectory = "/home/pengeg";
    stateVersion = "25.05";
  };
}
