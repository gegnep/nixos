{ inputs, ... }:

{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-yoga
  ];

  # Host Identity
  networking.hostName = "nixpad";
  system.stateVersion = "25.05";

  # Host Options
  hardware.intelgpu.vaapiDriver = "intel-media-driver";

  boot = {
    kernelParams = [ "i915.fastboot=1" ];
    extraModprobeConfig = ''
      options i915 enable_fbc=1 enable_psr=1
    '';
  };

  systemd.services.laptop-battery-thresholds = {
    description = "Set thresholds on battery charge";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      echo 75 > /sys/class/power_supply/BAT0/charge_start_threshold || true
      echo 90 > /sys/class/power_supply/BAT0/charge_stop_threshold || true
    '';
  };

  mySystem = {
    desktop = {
      wms = [ "niri" ];
      monitors = [
        {
          name = "eDP-1";
          width = 1920;
          height = 1200;
          refresh = 60.02;
          scale = 1.0;
          primary = true;
        }
      ];
    };
    hardware = {
      form = "laptop";
      gpu = "intel";
      swapfile = {
        enable = true;
        sizeGB = 16;
      };
      peripherals.wooting = false;
    };
    features = {
      gaming = false;
      streaming = false;
      audioProduction = false;
    };
    homelab = {
      cache.enable = true;
      remoteBuilder.enable = true;
    };
    backup = {
      enable = true;
      paths = [ "/home/pengeg" ];
    };
  };
}
