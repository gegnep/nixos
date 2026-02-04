{ pkgs, inputs, ... }:

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
  services = {
    flatpak.enable = true;
    udisks2.enable = true;
    tumbler.enable = true;
    gvfs.enable = true;
  };
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Boot to tty2
  systemd.services."getty@tty2".enable = true;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovty" = {
    description = "Switch to tty2 on boot";
    after = [ "systemd-user-sessions.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kbd}/bin/chvt 2";
    };
  };
}
