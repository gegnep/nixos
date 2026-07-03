{
  config,
  lib,
  ...
}:

let
  cfg = config.mySystem.homelab;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.cache.enable {
      nix.settings = {
        fallback = true;
        connect-timeout = 5;
        substituters = [ "http://homelab:5000" ];
        trusted-public-keys = [ "homelab-1:bmZMt7No1oGvTUNlBBm6OTeD17vRGTN1K6TNyNkSUWI=" ];
      };
    })

    (lib.mkIf cfg.remoteBuilder.enable {
      nix.distributedBuilds = true;
      nix.settings.builders-use-substituters = true;
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
      programs.ssh.extraConfig = ''
        Host homelab
          ConnectTimeout 10
          ServerAliveInterval 5
          ServerAliveCountMax 2
      '';
    })
  ];
}
