{ config, lib, ... }:

{
  imports = [ ./binds.nix ];

  programs.niri.settings = {
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
        accel-speed = -0.3;
      };
      touchpad = {
        tap = true;
        natural-scroll = false;
        click-method = "clickfinger";
        dwt = false; # disable-while-typing
      };
      focus-follows-mouse.enable = true;
    };

    # Outputs
    outputs = {
      "DP-2" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 74.973;
        };
        position = {
          x = 0;
          y = 0;
        };
        variable-refresh-rate = true;
      };
      "DP-1" = {
        mode = {
          width = 1600;
          height = 900;
          refresh = 60.0;
        };
        position = {
          x = -1600;
          y = 0;
        };
      };
      "DP-3" = {
        mode = {
          width = 1600;
          height = 900;
          refresh = 60.0;
        };
        position = {
          x = 1920;
          y = 0;
        };
      };
    };

    # Layout
    layout = {
      gaps = 4;
      border = {
        enable = true;
        width = 2;
        active.gradient = {
          from = "#f5c2e7";
          to = "#cba6f7";
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
          to = "#eba0ac";
          angle = 135;
          in' = "oklch shorter hue";
        };
      };
      focus-ring.enable = false;
      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 2.0; }
        { proportion = 2.0 / 3.0; }
      ];
      default-column-width = {
        proportion = 1.0 / 2.0;
      };
    };

    # Exec
    spawn-at-startup = [
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
          top-left = 8.0;
          top-right = 8.0;
          bottom-left = 8.0;
          bottom-right = 8.0;
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
    ];

    layer-rules = [
      {
        matches = [
          {
            namespace = "^noctalia-overview";
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

    # Animations
    animations.enable = true;

    # Fix rounded corners
    prefer-no-csd = true;
  };
}
