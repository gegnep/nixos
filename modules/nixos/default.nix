{ ... }:

{
  imports = [
    ./boot.nix
    ./desktop.nix
    ./flatpak.nix
    ./hardware
    ./homelab.nix
    ./networking.nix
    ./nix.nix
    ./options.nix
    ./performance.nix
    ./programs.nix
    ./restic.nix
    ./secrets.nix
    ./users.nix

    ./wm/hyprland.nix
    ./wm/niri.nix
  ];
}
