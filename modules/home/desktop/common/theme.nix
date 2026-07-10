{ pkgs, config, ... }:

{
  dconf.enable = true;

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "lavender";

    # opt-outs from autoEnable
    firefox.enable = false; # themed manually: userChrome + stylus (see README)
    # manual mocha palette in wm/hyprland; module injects a broken
    # lua-inline `colors` block into hyprlang (upstream bug)
    hyprland.enable = false;
    # cursor is phinger-cursors-light (set via home.pointerCursor below and
    # niri cursor.theme); catppuccin.cursors sets a conflicting
    # home.pointerCursor.name at normal priority -> eval conflict (issue #26)
    cursors.enable = false;
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-light";
    size = 36;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "kvantum";
  };

  catppuccin.kvantum.assertStyle = true;

  gtk = {
    enable = true;
    theme = {
      name = "Colloid-Purple-Dark-Catppuccin";
      package = pkgs.colloid-gtk-theme.override {
        themeVariants = [ "purple" ];
        colorVariants = [ "dark" ];
        sizeVariants = [ "standard" ];
        tweaks = [
          "catppuccin"
          "rimless"
          "normal"
        ];
      };
    };
    gtk4.theme = null;
    font = {
      name = "Hack Nerd Font";
      size = 12;
    };
    # iconTheme (catppuccin papirus folders) comes from catppuccin.gtk.icon
  };

  xdg.configFile = {
    "gtk-4.0/gtk.css".source =
      "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source =
      "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };
}
