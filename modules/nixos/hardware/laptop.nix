{ config, lib, ... }:

lib.mkIf (config.mySystem.hardware.form == "laptop") {
  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  boot = {
    kernelParams = [ "mem_sleep_default=s2idle" ];
    extraModprobeConfig = ''
      options snd_hda_intel power_save=1 power_save_controller=Y
      options iwlwifi power_save=1
      blacklist intel_gna
    '';
    kernel.sysctl = {
      "vm.dirty_writeback_centisecs" = 1500;
      "kernel.nmi_watchdog" = 0;
    };
  };

  # implies enableRedistributableFirmware (sof-firmware et al. for sound)
  hardware.enableAllFirmware = true;
}
