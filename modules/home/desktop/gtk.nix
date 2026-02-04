{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nwg-look
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-light";
    size = 36;
  };

  gtk = {
    enable = true;
    font = {
      name = "Hack Nerd Font";
      size = 12;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
    };
  };
}
