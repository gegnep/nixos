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
        accel-profile = "flat";
        accel-speed = 0.2;
      };
      touchpad = {
        tap = true;
        natural-scroll = false;
        click-method = "clickfinger";
        dwt = false; # disable-while-typing
      };
      focus-follows-mouse.enable = true;
      warp-mouse-to-focus.enable = true;
    };

    # Outputs
    outputs = {
      "DP-3" = {
        mode = {
          width = 2560;
          height = 1440;
          refresh = 170.0;
        };
        position = {
          x = 0;
          y = 0;
        };
        scale = 1.0;
        variable-refresh-rate = true;
      };
      "HDMI-A-1" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 100.0;
        };
        position = {
          x = -1920;
          y = 0;
        };
        scale = 1.0;
      };
    };

    #outputs = {
    #  "DP-2" = {
    #    mode = {
    #      width = 1920;
    #      height = 1080;
    #      refresh = 74.973;
    #    };
    #    position = {
    #      x = 0;
    #      y = 0;
    #    };
    #    variable-refresh-rate = true;
    #  };
    #  "DP-1" = {
    #    mode = {
    #      width = 1600;
    #      height = 900;
    #      refresh = 60.0;
    #    };
    #    position = {
    #      x = -1600;
    #      y = 0;
    #    };
    #  };
    #  "DP-3" = {
    #    mode = {
    #      width = 1600;
    #      height = 900;
    #      refresh = 60.0;
    #    };
    #    position = {
    #      x = 1920;
    #      y = 0;
    #    };
    #  };
    #};

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
      {
        matches = [
          {
            app-id = "^firefox$";
            title = "^Picture-in-Picture$";
          }
        ];
        open-floating = true;
        default-floating-position = {
          x = 20;
          y = 20;
          relative-to = "bottom-right";
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

    # Misc
    animations.enable = true;
    prefer-no-csd = true; # fix rounded corners
    screenshot-path = "~/pictures/screenshots/niri-%Y-%m-%d-%H-%M-%S.png";
    hotkey-overlay.skip-at-startup = true;
  };
}
