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
      "100.68.176.20" = [ "homelab" ];
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

  services.tailscale.enable = true;
  services.mullvad-vpn.enable = true;
}
