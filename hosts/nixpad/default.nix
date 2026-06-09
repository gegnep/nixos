{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "nixpad";
  system.stateVersion = "25.05";

  nix.distributedBuilds = true;

  nix.buildMachines = [
    {
      hostName = "homelab";
      sshUser = "nixremote";
      sshKey = "/root/.ssh/id_ed25519";
      systems = [ "x86_64-linux" ];
      protocol = "ssh-ng";
      maxJobs = 12;
      speedFactor = 20;
      supportedFeatures = [
        "big-parallel"
        "kvm"
        "nixos-test"
        "benchmark"
      ];
    }
  ];

  nix.settings = {
    builders-use-substitutes = true;
    substituters = [ "http://homelab:5000" ];
    trusted-public-keys = [ "homelab-1:bmZMt7No1oGvTUNlBBm6OTeD17vRGTN1K6TNyNkSUWI=%" ];
  };

  programs.ssh.knownHosts.homelab.publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOCsBF/ByfKwxSHfM9sCIxiqoSdEEJO0OYeUfFr8k2zh root@homelab";

  mySystem = {
    desktop = {
      wms = [ "niri" ];
      monitors = [
        {
          name = "e-DP-1";
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
      mcsr = false;
    };
  };
}
