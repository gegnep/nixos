{ config, lib, ... }:

{
  programs.niri.settings = {
    # Environment
    environment = {
      DISPLAY = null;
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
        };
        inactive.color = "#6c7086";
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

    # Key bindings
    binds =
      with config.lib.niri.actions;
      let
        noctalia =
          cmd:
          [
            "noctalia-shell"
            "ipc"
            "call"
          ]
          ++ (lib.splitString " " cmd);
      in
      {
        # Hotkey overlay
        "Mod+Shift+Slash".action = show-hotkey-overlay;

        # Apps
        "Mod+Q".action = spawn "ghostty";
        "Mod+E".action = spawn "dolphin";
        "Mod+Space".action.spawn = noctalia "launcher toggle";
        "Mod+Escape".action.spawn = noctalia "lockScreen lock";
        "Mod+Shift+M".action.spawn = noctalia "sessionMenu toggle";
        "Mod+Shift+Q".action = spawn "firefox";

        # Window management
        "Mod+Shift+C".action = close-window;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;

        # Focus (scrollable: H/L move along the strip, J/K within a column)
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Up".action = focus-window-up;
        "Mod+Down".action = focus-window-down;

        # Move
        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+Up".action = move-window-up;
        "Mod+Shift+Down".action = move-window-down;

        # Monitor (output) focus
        "Mod+Ctrl+Left".action = focus-monitor-left;
        "Mod+Ctrl+Right".action = focus-monitor-right;
        "Mod+Ctrl+Up".action = focus-monitor-up;
        "Mod+Ctrl+Down".action = focus-monitor-down;

        # Workspace navigation
        "Mod+Page_Up".action = focus-workspace-up;
        "Mod+Page_Down".action = focus-workspace-down;

        # Column width adjustments — niri-specific, very useful
        "Mod+Minus".action.set-column-width = [ "-10%" ];
        "Mod+Equal".action.set-column-width = [ "+10%" ];
        "Mod+Shift+Minus".action.set-window-height = [ "-10%" ];
        "Mod+Shift+Equal".action.set-window-height = [ "+10%" ];
        "Mod+R".action = switch-preset-column-width; # cycle through preset-column-widths
        "Mod+Shift+R".action = expand-column-to-available-width;

        # Consume/expel — move adjacent windows into/out of the current column
        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;
        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;

        # Move the focused column to another monitor
        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;

        # Move an entire workspace to another monitor
        "Mod+Alt+Left".action = move-workspace-to-monitor-left;
        "Mod+Alt+Right".action = move-workspace-to-monitor-right;

        # Move the focused column to a workspace up/down
        "Mod+Shift+Page_Up".action = move-column-to-workspace-up;
        "Mod+Shift+Page_Down".action = move-column-to-workspace-down;

        # Move a whole workspace up/down in the stack
        "Mod+Ctrl+Page_Up".action = move-workspace-up;
        "Mod+Ctrl+Page_Down".action = move-workspace-down;

        # Media keys
        "XF86AudioMute".action = spawn "pamixer" "-t";
        "XF86AudioLowerVolume".action = spawn "pamixer" "-d" "5";
        "XF86AudioRaiseVolume".action = spawn "pamixer" "-i" "5";
        "XF86AudioNext".action = spawn "playerctl" "next";
        "XF86AudioPrev".action = spawn "playerctl" "previous";
        "XF86AudioPlay".action = spawn "playerctl" "play-pause";

        # Brightness
        "XF86MonBrightnessDown".action = spawn "brightnessctl" "set" "5%-";
        "XF86MonBrightnessUp".action = spawn "brightnessctl" "set" "5%+";

        # Screenshots — niri has a built-in screenshot tool
        "Print".action.screenshot = [ ];

        # Floating
        "Mod+V".action = toggle-window-floating;
        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

        # The overview
        "Mod+Tab".action = toggle-overview;

        # Quit niri
        "Mod+Shift+Ctrl+M".action = quit;
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
          top-left = 20.0;
          top-right = 20.0;
          bottom-left = 20.0;
          bottom-right = 20.0;
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
