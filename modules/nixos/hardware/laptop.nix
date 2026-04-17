{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf (config.mySystem.hardware.form == "laptop") {
  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
    fwupd.enable = true;
    fprintd.enable = true;
  };

  networking.networkmanager.enable = true;
  powerManagement.enable = true;

  # ThinkPad specific
  hardware.trackpoint.enable = true;
}
