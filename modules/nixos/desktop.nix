{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:

{
  time.timeZone = "America/Kentucky/Louisville";
  i18n.defaultLocale = "en_US.UTF-8";

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

  services = {
    flatpak.enable = true;
    udisks2.enable = true;
  };
}
