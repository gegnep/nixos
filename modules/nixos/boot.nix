{ config, pkgs, inputs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    #kernelPackages = pkgs.linuxPackages_zen;
    kernelPackages = pkgs.linuxKernel.packagesFor 
      inputs.cachynix.packages.${pkgs.stdenv.hostPlatform.system}.linux-cachyos-latest-x86-64-v3;

    kernelParams = [
      "video=DP-3:2560x1440@170D"
      "video=HDMI-A-1:1920x1080@100"
      "amdgpu.ppfeaturemask=0xfffd7fff"
      "console=tty2"
    ];

    # v4l2loopback for OBS virtual camera
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
  };

  # Swap configuration
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 1024 * 32; # 32 GB
    options = [ "discard" ];
  }];

  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };

  services.fstrim.enable = true;
}
