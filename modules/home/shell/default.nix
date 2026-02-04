{ pkgs, ... }:

{
  imports = [
    ./zsh.nix
  ];

  home.sessionVariables = {
    HYPRSHOT_DIR = "$HOME/Pictures/Screenshots";
    BROWSER = "firefox";
    NIXOS_OZONE_WL = "1";
    XDG_DATA_DIRS = "/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS";
  };
}
