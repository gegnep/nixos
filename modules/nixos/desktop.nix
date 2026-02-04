{ pkgs, inputs, ... }:

let
  system = pkgs.system;
in
{
  time.timeZone = "America/Kentucky/Louisville";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.hyprland.enable = true;
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "lavender";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
  };

  security.polkit.enable = true;

  # Scheduler (CachyOS)
  services.scx.enable = true;

  # Misc services
  services.flatpak.enable = true;
  services.udisks2.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
