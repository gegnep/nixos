{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  isDesktop = config.mySystem.hardware.form == "desktop";
in
{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      grub.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    kernelPackages =
      if isDesktop then
        pkgs.linuxKernel.packagesFor
          inputs.cachynix.packages.${pkgs.stdenv.hostPlatform.system}.linux-cachyos-latest-x86-64-v3
      else
        pkgs.linuxPackages_latest;

    kernelParams = [
      "console=tty2"
      "quiet"
      "rd.udev.log_level=3"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelModules = [
      "ntsync"
    ]
    ++ lib.optional config.mySystem.features.streaming "v4l2loopback";

    extraModulePackages = lib.optional config.mySystem.features.streaming config.boot.kernelPackages.v4l2loopback;

    extraModprobeConfig = lib.optionalString config.mySystem.features.streaming ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
  };

  # Swap configuration
  swapDevices = lib.optional config.mySystem.hardware.swapfile.enable {
    device = "/var/lib/swapfile";
    size = config.mySystem.hardware.swapfile.sizeGB * 1024;
    options = [ "discard" ];
  };

  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };

  services.fstrim.enable = true;
}
