{ inputs, ... }:

{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix # generated on the device
    inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  networking.hostName = "theseus";
  system.stateVersion = "26.11"; # match what nixos-generate-config emits

  # upstream module leaves the i915 default; see the unverified list
  hardware.intelgpu = {
    driver = "xe";
    vaapiDriver = "intel-media-driver";
  };

  fileSystems."/mnt/homelab" = {
    device = "homelab:/";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
      "_netdev"
      "soft"
      "timeo=30"
      "retrans=2"
    ];
  };

  mySystem = {
    desktop = {
      wms = [ "niri" ];
      monitors = [
        {
          name = "eDP-1";
          width = 2880;
          height = 1920;
          refresh = 120.0; # placeholder, take the exact value from `niri msg outputs`
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
    };
    homelab.cache.enable = true;
    # remoteBuilder and backup stay off until the nixos-prod side exists
  };
}
