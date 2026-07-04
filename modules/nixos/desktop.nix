{ pkgs, config, ... }:

{
  time.timeZone = "America/Kentucky/Louisville";
  i18n.defaultLocale = "en_US.UTF-8";

  catppuccin = {
    enable = true;
    autoEnable = true;
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

  # CachyOS scheduler
  services.scx.enable = config.mySystem.hardware.form == "desktop";

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "gameoflife";
      clock = "%F %R";
      hide_borders = false;
      bigclock = "en";
    };
  };
  security.pam.services.ly.enableGnomeKeyring = true;

  services = {
    udisks2.enable = true;
    gvfs.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      sushi.enable = true;
    };
  };

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
    };
  };
}
