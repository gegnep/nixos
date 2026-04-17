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

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  boot.kernelParams = [
    "mem_sleep_default=s2idle"
    "i915.fastboot=1"
  ];

  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=1 power_save_controller=Y
    options iwlwifi power_save=1
    options i915 enable_fbc=1 enable_psr=1
    blacklist intel_gna
  '';

  boot.kernel.sysctl = {
    "vm.dirty_writeback_centisecs" = 1500;
    "kernel.nmi_watchdog" = 0;
  };

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

  hardware.trackpoint.enable = true; # nipple
  hardware.enableRedistributableFirmware = true; # "for now there is no sound"
  hardware.enableAllFirmware = true;
  environment.systemPackages = with pkgs; [
    sof-firmware
  ];

}
