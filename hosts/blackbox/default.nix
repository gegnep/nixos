{ ... }:

{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  # Host identity
  networking.hostName = "blackbox";
  system.stateVersion = "25.05";

  # Host options
  mySystem = {
    desktop = {
      wms = [
        "hyprland"
        "niri"
      ];
      monitors = [
        {
          name = "DP-3";
          width = 2560;
          height = 1440;
          refresh = 164.998;
          x = 0;
          y = 0;
          vrr = false;
          primary = true;
        }
        {
          name = "HDMI-A-1";
          width = 1920;
          height = 1080;
          refresh = 100.0;
          x = -1920;
          y = 0;
        }
      ];
    };
    hardware = {
      form = "desktop";
      gpu = "amd";
      swapfile = {
        enable = true;
        sizeGB = 32;
      };
      peripherals.wooting = true;
    };
    features = {
      gaming = true;
      streaming = true;
      audioProduction = true;
    };
    homelab.cache.enable = true;
    backup = {
      enable = true;
      paths = [
        "/home/pengeg"
        "/home/pengeg/xtra-stor"
      ];
      exclude = [
        "/home/pengeg/.wine"
        "/home/pengeg/.paradoxlauncher"
        "/home/pengeg/.phoronix-test-suite"
        "/home/pengeg/.local/share/Steam"
        "/home/pengeg/.local/share/bottles"
        "/home/pengeg/.var/app/com.usebottles.bottles"
        "/home/pengeg/.config/r2modman"
        "/home/pengeg/.config/r2modmanPlus-local"
        "/home/pengeg/.config/hd2arsenal"
        "/home/pengeg/.BitwigStudio/installed-packages"
        "/home/pengeg/.BitwigStudio/cache"
        "/home/pengeg/.BitwigStudio/log"
        # xtra-stor: keep oldhome/resolve-projects/obs-recordings, drop the rest
        "/home/pengeg/xtra-stor/SteamLibrary"
        "/home/pengeg/xtra-stor/lost+found"
        "/home/pengeg/xtra-stor/.Trash-1000"
        # oldhome is a copied homedir — the common excludes are anchored at
        # /home/pengeg/ and don't reach in here, so re-anchor the fat ones
        "/home/pengeg/xtra-stor/oldhome/.cache"
        "/home/pengeg/xtra-stor/oldhome/downloads"
        "/home/pengeg/xtra-stor/oldhome/.local/share/Steam"
        "/home/pengeg/xtra-stor/oldhome/.local/share/Trash"
      ];
    };
  };
}
