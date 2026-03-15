{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nwg-look
  ];

  dconf.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-light";
    size = 36;
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  catppuccin.kvantum = {
    enable = true;
    flavor = "mocha";
    accent = "lavender";
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
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
