{ config, lib, ... }:

{
  programs.niri.settings.binds =
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

      # Bind arrows and vim-style keys to same action
      dirs = mod: actions: {
        "${mod}+Left".action = actions.left;
        "${mod}+H".action = actions.left;
        "${mod}+Right".action = actions.right;
        "${mod}+L".action = actions.right;
        "${mod}+Up".action = actions.up;
        "${mod}+K".action = actions.up;
        "${mod}+Down".action = actions.down;
        "${mod}+J".action = actions.down;
      };
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

      # Workspaces on this monitor
      "Mod+Page_Up".action = focus-workspace-up;
      "Mod+Page_Down".action = focus-workspace-down;

      # Column to another workspace on this monitor
      "Mod+Shift+Page_Up".action = move-column-to-workspace-up;
      "Mod+Shift+Page_Down".action = move-column-to-workspace-down;

      # Move a whole workspace up/down in the stack
      "Mod+Alt+Page_Up".action = move-workspace-up;
      "Mod+Alt+Page_Down".action = move-workspace-down;

      # Column width adjustments — niri-specific, very useful
      "Mod+Minus".action.set-column-width = [ "-10%" ];
      "Mod+Equal".action.set-column-width = [ "+10%" ];
      "Mod+Shift+Minus".action.set-window-height = [ "-10%" ];
      "Mod+Shift+Equal".action.set-window-height = [ "+10%" ];
      "Mod+R".action = switch-preset-column-width;
      "Mod+Shift+R".action = expand-column-to-available-width;

      # Consume/expel — move adjacent windows into/out of the current column
      "Mod+Comma".action = consume-window-into-column;
      "Mod+Period".action = expel-window-from-column;
      "Mod+BracketLeft".action = consume-or-expel-window-left;
      "Mod+BracketRight".action = consume-or-expel-window-right;

      # Media keys
      "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
      "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
      "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
      "Shift+XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
      "XF86AudioNext".action = spawn "playerctl" "next";
      "XF86AudioPrev".action = spawn "playerctl" "previous";
      "XF86AudioPlay".action = spawn "playerctl" "play-pause";

      # Brightness
      "XF86MonBrightnessDown".action = spawn "brightnessctl" "set" "5%-";
      "XF86MonBrightnessUp".action = spawn "brightnessctl" "set" "5%+";

      # Screenshots
      "Print".action.screenshot = [ ];

      # Floating
      "Mod+V".action = toggle-window-floating;
      "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

      # The overview
      "Mod+Tab".action = toggle-overview;

      # Quit niri
      "Mod+Shift+Ctrl+M".action = quit;
    }
    // dirs "Mod" {
      # Focus columns on the strip
      left = focus-column-left;
      right = focus-column-right;
      # Focus windows in a column
      up = focus-window-up;
      down = focus-window-down;
    }
    // dirs "Mod+Ctrl" {
      # Change focused monitor
      left = focus-monitor-left;
      right = focus-monitor-right;
      up = focus-monitor-up;
      down = focus-monitor-down;
    }
    // dirs "Mod+Shift" {
      # Move focused column on the strip
      left = move-column-left;
      right = move-column-right;
      # Move focused window in a column
      up = move-window-up;
      down = move-window-down;
    }
    // dirs "Mod+Shift+Ctrl" {
      # Move focused column to another monitor
      left = move-column-to-monitor-left;
      right = move-column-to-monitor-right;
      up = move-column-to-monitor-up;
      down = move-column-to-monitor-down;
    }
    // dirs "Mod+Alt" {
      # Move an entire workspace to another monitor
      left = move-workspace-to-monitor-left;
      right = move-workspace-to-monitor-right;
      up = move-workspace-to-monitor-up;
      down = move-workspace-to-monitor-down;
    };
}
