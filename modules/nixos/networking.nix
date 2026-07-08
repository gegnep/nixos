{ config, lib, ... }:
let
  isLaptop = config.mySystem.hardware.form == "laptop";
in
{
  networking = {
    nameservers = [
      "100.68.176.20" # homelab tailnet ip
      "1.1.1.1"
      "1.0.0.1"
    ];
    search = [ "ermine-gentoo.ts.net" ];
    hosts = {
      # /etc/hosts can't wildcard *.homelab; list service names here.
      # Static entries survive the resolved current-server rotation that
      # otherwise NXDOMAINs .homelab whenever it lands on Cloudflare.
      "100.68.176.20" = [
        "homelab"
        "git.homelab"
      ];
      "100.101.53.21" = [ "blackbox" ];
      "100.76.124.81" = [ "nixpad" ];
    };
    networkmanager.enable = isLaptop;
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      trustedInterfaces = [ "tailscale0" ];
      allowedTCPPortRanges = lib.optionals config.mySystem.features.gaming [
        {
          from = 27000;
          to = 27050;
        }
      ];

      allowedUDPPortRanges = lib.optionals config.mySystem.features.gaming [
        {
          from = 27000;
          to = 27050;
        }
      ];
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "allow-downgrade";
      Domains = [ "~." ];
      FallbackDNS = [
        "100.100.100.100"
        "1.1.1.1"
        "1.0.0.1"
      ];
      DNSOverTLS = "opportunistic";
    };
  };

  programs.ssh.knownHosts = {
    homelab.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOCsBF/ByfKwxSHfM9sCIxiqoSdEEJO0OYeUfFr8k2zh";
    "github.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    "gitlab.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
  };

  services.tailscale.enable = true;
  services.mullvad-vpn.enable = true;
}
