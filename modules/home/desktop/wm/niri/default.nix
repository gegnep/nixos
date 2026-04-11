{ config, ... }:

{
  programs.niri.settings = {
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
          refresh = 75.0;
        };
        position = {
          x = 0;
          y = 0;
        };
        variable-refresh-rate = true;
      };
      "DP-1" = {
        position = {
          x = -1920;
          y = 0;
        }; # auto-left equivalent
      };
      "DP-3" = {
        position = {
          x = 1920;
          y = 0;
        }; # auto-right equivalent
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

    # Key bindings — noctalia IPC for launcher and session menu, ghostty for terminal
    binds =
      with config.lib.niri.actions;
      let
        sh = spawn "sh" "-c";
      in
      {
        # Apps
        "Mod+Q".action = spawn "ghostty";
        "Mod+E".action = spawn "dolphin";
        "Mod+R".action = sh "noctalia-shell ipc call launcher toggle";
        "Mod+L".action = sh "noctalia-shell ipc call lockScreen lock";
        "Mod+Shift+M".action = sh "noctalia-shell ipc call sessionMenu toggle";
        "Mod+Shift+Q".action = spawn "firefox";
        "Mod+Shift+D".action = spawn "discord";
        "Mod+Shift+K".action = spawn "keepassxc";

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

        # Workspaces (vertical in niri)
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+Shift+1".action.move-column-to-workspace = [ 1 ];
        "Mod+Shift+2".action.move-column-to-workspace = [ 2 ];
        "Mod+Shift+3".action.move-column-to-workspace = [ 3 ];
        "Mod+Shift+4".action.move-column-to-workspace = [ 4 ];
        "Mod+Shift+5".action.move-column-to-workspace = [ 5 ];

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

        # Quit niri
        "Mod+Shift+E".action = quit;
      };

    # Don't autostart noctalia from niri config — the systemd service handles it
    spawn-at-startup = [ ];

    # Cursor
    cursor = {
      theme = "phinger-cursors-light";
      size = 36;
    };

    # Animations — niri's defaults are tasteful, just tweak slightly
    animations.enable = true;
  };
}
