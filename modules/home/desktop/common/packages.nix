{ pkgs, ... }:

{
  home.packages = with pkgs; [
    playerctl
    brightnessctl
    wl-clipboard
    wlr-randr
    xrandr
    pwvucontrol
  ];
}
