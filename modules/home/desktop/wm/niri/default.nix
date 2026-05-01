{
  config,
  inputs,
  lib,
  pkgs,
  hostOptions,
  ...
}:

let
  mkOutput = m: {
    name = m.name;
    value = {
      mode = {
        width = m.width;
        height = m.height;
        refresh = m.refresh;
      };
      position = {
        x = m.x;
        y = m.y;
      };
      scale = m.scale;
    }
    // lib.optionalAttrs m.vrr {
      variable-refresh-rate = true;
    };
  };
  niriPkgs = inputs.niri-pkgs.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    inputs.niri.homeModules.niri
    ./binds.nix
  ];

  programs.niri = {
    package = niriPkgs.niri-unstable;
    settings = {
      # Import config options not yet in the flake
      includes = lib.mkAfter [
        (./extra-config.kdl)
      ];

      # Environment
      environment = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };

      # Input
      input = {
        keyboard.xkb = {
          layout = "us";
        };
        mouse = {
          accel-profile = "flat";
          accel-speed = 0.2;
        };
        touchpad = {
          tap = true;
          natural-scroll = false;
          click-method = "clickfinger";
          dwt = true; # disable-while-typing
          middle-emulation = true; # three finger tap = middle click
          scroll-method = "two-finger";
          accel-profile = "adaptive";
          accel-speed = 0.3;
          tap-button-map = "left-right-middle";
        };
        tablet = {
          map-to-output = "eDP-1";
        };
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };
        warp-mouse-to-focus.enable = true;
      };

      # Outputs
      outputs = lib.listToAttrs (map mkOutput hostOptions.desktop.monitors);

      # Layout
      layout = {
        gaps = 8;
        border = {
          enable = true;
          width = 4;
          active.gradient = {
            from = "#cba6f7";
            to = "#89b4fa";
            angle = 135;
            in' = "oklch shorter hue";
          };
          inactive.gradient = {
            from = "#6c7086";
            to = "#45475a";
            angle = 135;
            in' = "oklch shorter hue";
          };
          urgent.gradient = {
            from = "#f38ba8";
            to = "#fab387";
            angle = 135;
            in' = "oklch shorter hue";
          };
        };
        background-color = "transparent";
        focus-ring.enable = false;
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];
        default-column-width = {
          proportion = 1.0 / 2.0;
        };
        preset-window-heights = [
          { proportion = 1.0 / 5.0; }
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
        ];
      };

      # Exec
      spawn-at-startup = [
        {
          command = [
            "sh -c"
            "dbus-update-activation-environment --systemd --all && systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-gtk.service"
          ];
        }
        {
          command = [
            "noctalia-shell"
          ];
        }
      ];

      # Rules
      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 12.0;
            top-right = 12.0;
            bottom-left = 12.0;
            bottom-right = 12.0;
          };
          clip-to-geometry = true;
        }
        {
          matches = [
            {
              app-id = "^steam$";
              title = "^notificationtoasts_";
            }
          ];
          open-floating = true;
          open-focused = false;
          default-floating-position = {
            x = 12;
            y = 12;
            relative-to = "bottom-right";
          };
        }
        {
          matches = [
            {
              app-id = "^steam$";
              title = "^Friends List";
            }
          ];
          open-floating = true;
        }
        {
          matches = [
            {
              app-id = "^com\\.mitchellh\\.ghostty$";
            }
          ];
          opacity = 1.0;
        }
        {
          matches = [
            {
              app-id = "^firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
          default-floating-position = {
            x = 12;
            y = 12;
            relative-to = "top-right";
          };
        }
        {
          matches = [
            {
              app-id = "^org\\.keepassxc\\.KeePassXC$";
            }
          ];
          open-floating = true;
          block-out-from = "screen-capture";
        }
      ];

      layer-rules = [
        {
          matches = [
            {
              namespace = "^noctalia-wallpaper";
            }
          ];
          place-within-backdrop = true;
        }
      ];

      # Cursor
      cursor = {
        theme = "phinger-cursors-light";
        size = 36;
      };

      # Misc
      animations.enable = true;
      prefer-no-csd = true; # fix rounded corners
      screenshot-path = "~/pictures/screenshots/niri-%Y-%m-%d-%H-%M-%S.png";
      hotkey-overlay.skip-at-startup = true;
    };
  };
}
