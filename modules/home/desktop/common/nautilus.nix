{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    nautilus
    ffmpegthumbnailer
  ];

  gtk.gtk3.bookmarks = [
    "file:///home/pengeg/downloads dwnld"
    "file:///home/pengeg/documents doc"
    "file:///home/pengeg/pictures pic"
    "file:///home/pengeg/Sync sync"
    "file:///home/pengeg/nixos nix"
    "file:///mnt/homelab homelab"
  ];

  dconf.settings = {
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      show-delete-permanently = true;
    };
    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      view-type = "list";
      sort-directories-first = true;
    };
    "org/gtk/settings/file-chooser" = {
      view-type = "list";
      sort-directories-first = true;
    };
  };
}
