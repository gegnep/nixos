{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # general laptop utils
    libwacom
    wvkbd
    rnote
    xournalpp
    wl-mirror
    hyprpicker
    gnome-network-displays
  ];
}
