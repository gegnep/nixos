{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # general laptop utils
    libwacom
    wvkbd
    rnote
    xournalpp
    wl-mirror
    hyprpicker

    # misc utils
    gnome-network-displays

    # work
    slack
    kiro
  ];
}
