{ pkgs, ... }:

{
  home.packages = with pkgs; [
    playerctl
    brightnessctl
    cliphist
    wl-clipboard
    wlr-randr
    udiskie
    xrandr
    pwvucontrol
  ];
}
