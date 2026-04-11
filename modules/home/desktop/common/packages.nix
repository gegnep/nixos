{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pamixer
    playerctl
    brightnessctl
    cliphist
    wl-clipboard
    wlr-randr
    udiskie
    xrandr
  ];
}
