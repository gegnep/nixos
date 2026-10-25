{
  config,
  pkgs,
  lib,
  ...
}:

let
  isDesktop = config.mySystem.hardware.form == "desktop";

  # nixpkgs#576406: kernel.dev now ships System.map, so kbuild's modules_install
  # runs depmod into the module's own output. Those modules.* files collide with
  # the kernel's in aggregateModules, which regenerates them anyway. Drop this
  # override once #576406 is fixed and nyx has rebuilt against the fix.
  v4l2loopback = config.boot.kernelPackages.v4l2loopback.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      rm -f $out/lib/modules/*/modules.*
    '';
  });
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

    kernelPackages = if isDesktop then pkgs.linuxPackages_cachyos else pkgs.linuxPackages_latest;

    kernelParams = [
      "console=tty1"
      "quiet"
      "rd.udev.log_level=3"
    ]
    ++ lib.optional isDesktop "ttm.page_pool_size=2097152";

    consoleLogLevel = 0;

    kernelModules = [
      "ntsync"
      "vhost_vsock"
    ]
    ++ lib.optional config.mySystem.features.streaming "v4l2loopback";

    extraModulePackages = lib.optional config.mySystem.features.streaming v4l2loopback;

    extraModprobeConfig = lib.optionalString config.mySystem.features.streaming ''
      options v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1
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
