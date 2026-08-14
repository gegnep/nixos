{ lib, ... }:

let
  # `act "focus-column-left"` → { focus-column-left = { }; } (argument-less action node)
  act = name: { ${name} = { }; };
  spawn = args: { spawn = args; };
  noctalia =
    cmd:
    spawn (
      [
        "noctalia"
        "msg"
      ]
      ++ (lib.splitString " " cmd)
    );

  # Bind arrow and vim-style keys to same action; scroll wheel up/down == left/right
  dirs = mod: actions: {
    "${mod}+Left" = actions.left;
    "${mod}+H" = actions.left;
    "${mod}+WheelScrollUp" = actions.left;

    "${mod}+Right" = actions.right;
    "${mod}+L" = actions.right;
    "${mod}+WheelScrollDown" = actions.right;

    "${mod}+Up" = actions.up;
    "${mod}+K" = actions.up;

    "${mod}+Down" = actions.down;
    "${mod}+J" = actions.down;
  };

  # Bind page up/down and mouse forward/back to the same action
  stack = mod: actions: {
    "${mod}+Page_Up" = actions.up;
    "${mod}+MouseForward" = actions.up;

    "${mod}+Page_Down" = actions.down;
    "${mod}+MouseBack" = actions.down;
  };
in
{
  wayland.windowManager.niri.settings.binds = {
    # Misc
    "Mod+Shift+Slash" = act "show-hotkey-overlay";
    "Mod+Tab" = act "toggle-overview";
    "Mod+Ctrl+Shift+M" = act "quit";
    "Mod+Shift+P" = act "power-off-monitors";

    # Apps & Bar controls
    "Mod+Q" = spawn [ "ghostty" ];
    "Mod+E" = spawn [ "nautilus" ];
    "Mod+B" = spawn [ "firefox" ];
    "Mod+Space" = noctalia "panel-toggle launcher";
    "Mod+Ctrl+Space" = noctalia "panel-toggle gegnep/claude-launcher:chat";
    "Mod+Escape" = noctalia "session lock";
    "Mod+M" = noctalia "panel-toggle session";
    "Mod+N" = noctalia "notification-dnd-toggle";
    "Mod+C" = noctalia "panel-toggle control-center";
    "Mod+X" = noctalia "panel-toggle clipboard";
    "Mod+Shift+U" = spawn [ "paste-clip" ];

    # Screenshots
    "Print" = act "screenshot";
    "Mod+Print" = act "screenshot-screen";
    "Mod+Shift+Print" = act "screenshot-window";

    # Window management
    "Mod+Shift+C" = act "close-window";
    "Mod+Shift+F" = act "fullscreen-window";
    "Mod+W" = act "center-column";

    # Floating
    "Mod+V" = act "toggle-window-floating";
    "Mod+Shift+V" = act "switch-focus-between-floating-and-tiling";

    # Media keys
    "XF86AudioMute" = spawn [
      "wpctl"
      "set-mute"
      "@DEFAULT_AUDIO_SINK@"
      "toggle"
    ];
    "XF86AudioLowerVolume" = spawn [
      "wpctl"
      "set-volume"
      "@DEFAULT_AUDIO_SINK@"
      "5%-"
    ];
    "XF86AudioRaiseVolume" = spawn [
      "wpctl"
      "set-volume"
      "@DEFAULT_AUDIO_SINK@"
      "5%+"
    ];
    "Shift+XF86AudioMute" = spawn [
      "wpctl"
      "set-mute"
      "@DEFAULT_AUDIO_SOURCE@"
      "toggle"
    ];
    "XF86AudioNext" = noctalia "media next";
    "XF86AudioPrev" = noctalia "media previous";
    "XF86AudioPlay" = noctalia "media toggle";

    # Brightness
    "XF86MonBrightnessDown" = spawn [
      "brightnessctl"
      "set"
      "5%-"
    ];
    "XF86MonBrightnessUp" = spawn [
      "brightnessctl"
      "set"
      "5%+"
    ];

    # Column/Window width/height adjustments
    "Mod+R" = act "switch-preset-column-width";
    "Mod+Ctrl+R" = act "expand-column-to-available-width"; # expands column to the rest of the empty space on the monitor, keeping other columns
    "Mod+F" = act "maximize-column"; # expands column to 100%, forcing out any other column
    "Mod+Minus".set-column-width = "-10%";
    "Mod+Equal".set-column-width = "+10%";

    "Mod+Shift+R" = act "switch-preset-window-height";
    "Mod+Ctrl+Shift+R" = act "reset-window-height";
    "Mod+Shift+Minus".set-window-height = "-10%";
    "Mod+Shift+Equal".set-window-height = "+10%";

    # Consume/expel — move adjacent windows into/out of the current column
    "Mod+Comma" = act "consume-window-into-column";
    "Mod+Period" = act "expel-window-from-column";
    "Mod+BracketLeft" = act "consume-or-expel-window-left";
    "Mod+BracketRight" = act "consume-or-expel-window-right";
  }
  # --- Navigation ---

  ### General philosophy with navigation keys:
  ### No modifier, change focus
  ### Shift, moves focused
  ### Ctrl, work across monitors
  ### Alt, act on an entire workspace

  ### Key Equivelants:
  # left/right/up/down
  # h/l/k/j
  # scroll wheel up/scroll wheel down/null/null

  // dirs "Mod" {
    # Focus columns on the strip
    left = act "focus-column-left";
    right = act "focus-column-right";
    # Focus windows in a column
    up = act "focus-window-up";
    down = act "focus-window-down";
  }
  // dirs "Mod+Shift" {
    # Move focused column on the strip
    left = act "move-column-left";
    right = act "move-column-right";
    # Move focused window in a column
    up = act "move-window-up";
    down = act "move-window-down";
  }
  // dirs "Mod+Ctrl" {
    # Change focused monitor
    left = act "focus-monitor-left";
    right = act "focus-monitor-right";
    up = act "focus-monitor-up";
    down = act "focus-monitor-down";
  }
  // dirs "Mod+Ctrl+Shift" {
    # Move focused column to another monitor
    left = act "move-column-to-monitor-left";
    right = act "move-column-to-monitor-right";
    up = act "move-column-to-monitor-up";
    down = act "move-column-to-monitor-down";
  }
  // dirs "Mod+Alt" {
    # Move an entire workspace to another monitor
    left = act "move-workspace-to-monitor-left";
    right = act "move-workspace-to-monitor-right";
    up = act "move-workspace-to-monitor-up";
    down = act "move-workspace-to-monitor-down";
  }

  ### Key Equivelants:
  # page up/page down
  # mouse forward/mouse back

  // stack "Mod" {
    # Change focused workspace
    up = act "focus-workspace-up";
    down = act "focus-workspace-down";
  }
  // stack "Mod+Shift" {
    # Move column to another workspace
    up = act "move-column-to-workspace-up";
    down = act "move-column-to-workspace-down";
  }
  // stack "Mod+Alt" {
    # Move workspace in the stack
    up = act "move-workspace-up";
    down = act "move-workspace-down";
  };
}
