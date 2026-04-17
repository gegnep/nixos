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

  powerManagement.enable = true;

  systemd.services.laptop-battery-thresholds = {
    description = "Set thresholds on battery charge";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig.type = "oneshot";
    script = ''
      echo 75 > /sys/class/power_supply/BAT0/charge_start_threshold || true
      echo 90 > /sys/class/power_supply/BAT0/charge_stop_threshold || true
    '';
  };

  # ThinkPad specific
  hardware.trackpoint.enable = true; # nipple
  hardware.enableRedistributableFirmware = true; # "for now there is no sound"
  hardware.enableAllFirmware = true;
  environment.systemPackages = with pkgs; [
    sof-firmware
  ];
}
