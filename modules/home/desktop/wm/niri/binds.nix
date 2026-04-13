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

      # Focus
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

      # Move the focused column to a workspace up/down
      "Mod+Shift+Page_Up".action = move-column-to-workspace-up;
      "Mod+Shift+Page_Down".action = move-column-to-workspace-down;

      # Move a whole workspace up/down in the stack
      "Mod+Alt+Page_Up".action = move-workspace-up;
      "Mod+Alt+Page_Down".action = move-workspace-down;

      # Move the focused column to another monitor
      "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
      "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;

      # Move an entire workspace to another monitor
      "Mod+Alt+Left".action = move-workspace-to-monitor-left;
      "Mod+Alt+Right".action = move-workspace-to-monitor-right;

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
    };
}
