{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nwg-look
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "lavender" ];
     })
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

  xdg.configFile."kdeglobals".text = ''
    [General]
    ColorScheme=CatppuccinMochaLavender

    [Icons]
    Theme=Papirus-Dark

    [KDE]
    widgetStyle=kvantum
  '';
}
