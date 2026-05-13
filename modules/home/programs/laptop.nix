{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    libwacom
    wvkbd

    rnote
    xournalpp

    wl-mirror
    hyprpicker
  ];
}
