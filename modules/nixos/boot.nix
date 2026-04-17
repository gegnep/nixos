{
  config,
  pkgs,
  inputs,
  ...
}:

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

    #kernelPackages = pkgs.linuxPackages_zen;
    kernelPackages =
      pkgs.linuxKernel.packagesFor
        inputs.cachynix.packages.${pkgs.stdenv.hostPlatform.system}.linux-cachyos-latest-x86-64-v3;

    kernelParams = [
      "console=tty2"
      "quiet"
      "rd.udev.log_level=3"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelModules = [
      "v4l2loopback"
      "ntsync"
    ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
  };

  # Swap configuration
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 1024 * 32; # 32 GB
      options = [ "discard" ];
    }
  ];

  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };

  services.fstrim.enable = true;
}
