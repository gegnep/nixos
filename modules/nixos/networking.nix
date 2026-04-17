{ config, lib, ... }:
let
  isLaptop = config.mySystem.hardware.form == "laptop";
in
{
  networking = {
    nameservers = [
      "100.100.100.100"
      "1.1.1.1"
      "1.0.0.1"
    ];
    search = [ "ermine-gentoo.ts.net" ];
    networkmanager.enable = isLaptop;
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      trustedInterfaces = [ "tailscale0" ];
      allowedTCPPortRanges = [
        {
          from = 27000;
          to = 27050;
        }
      ];
      allowedUDPPortRanges = [
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
      DNSSEC = "true";
      Domains = [ "~." ];
      FallbackDNS = [
        "100.100.100.100"
        "1.1.1.1"
        "1.0.0.1"
      ];
      DNSOverTLS = "true";
    };
  };

  services.tailscale.enable = true;
  services.mullvad-vpn.enable = true;
}
