{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
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
      paths = [ "/home/pengeg" ];
      exclude = [
        # caches & regenerable
        "/home/pengeg/.cache"
        "/home/pengeg/downloads"
        "/home/pengeg/.cargo"
        "/home/pengeg/.npm"
        "/home/pengeg/.zplug"
        "/home/pengeg/.compose-cache"
        "/home/pengeg/.java"
        "/home/pengeg/.wine"
        "/home/pengeg/.paradoxlauncher"
        "/home/pengeg/.phoronix-test-suite"
        "**/.direnv"
        "**/node_modules"

        # game platforms / wine prefixes / mod caches (re-downloadable;
        # see caveats: Steam compatdata + bottles can hold non-cloud saves)
        "/home/pengeg/.local/share/Steam"
        "/home/pengeg/.local/share/bottles"
        "/home/pengeg/.var/app/com.usebottles.bottles"
        "/home/pengeg/.local/share/pnpm"
        "/home/pengeg/.local/share/Trash"
        "/home/pengeg/.config/r2modman"
        "/home/pengeg/.config/r2modmanPlus-local"
        "/home/pengeg/.config/hd2arsenal"

        # Bitwig: keep prefs/presets, drop the re-downloadable content library
        "/home/pengeg/.BitwigStudio/installed-packages"
        "/home/pengeg/.BitwigStudio/cache"
        "/home/pengeg/.BitwigStudio/log"

        # electron cache dirs inside otherwise-kept .config apps
        "/home/pengeg/.config/*/Cache"
        "/home/pengeg/.config/*/Code Cache"
        "/home/pengeg/.config/*/GPUCache"
        "/home/pengeg/.config/*/Service Worker"

        # chat clients are server-synced; keep only the claude sandboxes
        "/home/pengeg/.bwrapper/vesktop"
        "/home/pengeg/.bwrapper/slack"
        "/home/pengeg/.bwrapper/*/.cache"
        "/home/pengeg/.bwrapper/*/.npm"
      ];
    };
  };
}
