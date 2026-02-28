{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprpolkitagent
    hyprshot
    pamixer
    playerctl
    brightnessctl
    fuzzel
    cliphist
    wl-clipboard
    wlr-randr
    udiskie
    pcmanfm
    feh
    xrandr
    imv
    mpv
    zathura

    # Quickshell/Noctalia dependencies
    qt6Packages.qt5compat
    libsForQt5.qtgraphicaleffects
    cava
    gpu-screen-recorder
    material-symbols

    python3
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    settings = {
      # Catppuccin Mocha colors
      "$rosewater" = "0xfff5e0dc";
      "$flamingo"  = "0xfff2cdcd";
      "$pink"      = "0xfff5c2e7";
      "$mauve"     = "0xffcba6f7";
      "$red"       = "0xfff38ba8";
      "$maroon"    = "0xffeba0ac";
      "$peach"     = "0xfffab387";
      "$green"     = "0xffa6e3a1";
      "$teal"      = "0xff94e2d5";
      "$sky"       = "0xff89dceb";
      "$sapphire"  = "0xff74c7ec";
      "$blue"      = "0xff89b4fa";
      "$lavender"  = "0xffb4befe";
      "$text"      = "0xffcdd6f4";
      "$subtext1"  = "0xffbac2de";
      "$subtext2"  = "0xffa6adc8";
      "$overlay2"  = "0xff9399b2";
      "$overlay1"  = "0xff7f849c";
      "$overlay0"  = "0xff6c7086";
      "$surface2"  = "0xff585b70";
      "$surface1"  = "0xff45475a";
      "$surface0"  = "0xff313244";
      "$base"      = "0xff1e1e2e";
      "$mantle"    = "0xff181825";
      "$crust"     = "0xff11111b";

      # Monitors
      monitor = [
        "DP-3, 2560x1440@170, 0x0, 1, vrr, 3"
        "HDMI-A-1, 1920x1080@100, auto-left, 1"
      ];

      # General settings
      general = {
        gaps_in = 4;
        gaps_out = 4;
        border_size = 2;
        "col.active_border" = "$pink $lavender $mauve 135deg";
        "col.inactive_border" = "$overlay0 $surface2 $surface0 45deg";
        layout = "dwindle";
      };

      input = {
        kb_layout = "us";
        repeat_rate = 25;
        repeat_delay = 500;
        sensitivity = -0.3;
        follow_mouse = 1;
        touchpad = {
          disable_while_typing = false;
          natural_scroll = false;
          clickfinger_behavior = true;
          tap-to-click = true;
          drag_lock = false;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "fade, 1, 7, default"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "workspaces, 1, 6, default"
        ];
      };

      decoration = {
        rounding = 4;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          new_optimizations = true;
        };
      };

      dwindle = {
        pseudotile = true;
        force_split = 0;
        preserve_split = true;
      };

      # Startup
      exec-once = [
        "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "systemctl --user start hyprpolkitagent"
        "noctalia-shell"
        "keepassxc --minimized"
      ];

      # Window rules
      windowrule = [
        # Steam
        "no_focus on, match:class ^(steam)$, match:title ^(notificationtoasts_.*_desktop)$"
        "stay_focused on, match:class ^(steam)$, match:title ^()$"
        "min_size 1 1, match:class ^(steam)$, match:title ^()$"

        # Firefox p-i-p
        "float on, pin on, match:class ^(firefox)$, match:title ^(Picture-in-Picture)$"

        # Fix Bitwig sliders and knobs (Issue #2034)
        "no_focus on, match:class ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
      ];

      # Keybinds
      "$mainMod" = "SUPER";
      "$shiftMod" = "$mainMod SHIFT";
      "$altMod" = "$mainMod ALT";
      "$ctrlMod" = "$mainMod CTRL";

      bind = [
        "$shiftMod, M, exec, noctalia-shell ipc call sessionMenu toggle"
        "$shiftMod, C, killactive"
        "$mainMod, V, togglefloating"
        "$mainMod, F, fullscreen, 1"
        "$shiftMod, F, fullscreen, 0"
        "$mainMod, J, togglesplit"
        "$mainMod, P, pseudo"
        "$shiftMod, P, pin"

        "$shiftMod, S, swapactiveworkspaces, HDMI-A-1 DP-3"

        # Focus movement
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Window movement
        "$shiftMod, left, movewindow, l"
        "$shiftMod, right, movewindow, r"
        "$shiftMod, up, movewindow, u"
        "$shiftMod, down, movewindow, d"

        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move to workspace
        "$shiftMod, 1, movetoworkspace, 1"
        "$shiftMod, 2, movetoworkspace, 2"
        "$shiftMod, 3, movetoworkspace, 3"
        "$shiftMod, 4, movetoworkspace, 4"
        "$shiftMod, 5, movetoworkspace, 5"
        "$shiftMod, 6, movetoworkspace, 6"
        "$shiftMod, 7, movetoworkspace, 7"
        "$shiftMod, 8, movetoworkspace, 8"
        "$shiftMod, 9, movetoworkspace, 9"
        "$shiftMod, 0, movetoworkspace, 10"

        # Silent move to workspace
        "$altMod, 1, movetoworkspacesilent, 1"
        "$altMod, 2, movetoworkspacesilent, 2"
        "$altMod, 3, movetoworkspacesilent, 3"
        "$altMod, 4, movetoworkspacesilent, 4"
        "$altMod, 5, movetoworkspacesilent, 5"
        "$altMod, 6, movetoworkspacesilent, 6"
        "$altMod, 7, movetoworkspacesilent, 7"
        "$altMod, 8, movetoworkspacesilent, 8"
        "$altMod, 9, movetoworkspacesilent, 9"
        "$altMod, 0, movetoworkspacesilent, 10"

        # Scroll workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Applications
        "$mainMod, E, exec, pcmanfm"
        "$mainMod, Q, exec, alacritty"
        "$mainMod, R, exec, noctalia-shell ipc call launcher toggle"
        "$shiftMod, Q, exec, firefox"
        "$shiftMod, D, exec, discord"
        "$shiftMod, K, exec, keepassxc"

        # Media keys
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        "SHIFT, XF86AudioMute, exec, pamixer --default-source -t"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"

        # Brightness
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"

        # Screenshots
        ", PRINT, exec, hyprshot -z -m output"
        "$mainMod, PRINT, exec, hyprshot -z -m window"
        "$shiftMod, PRINT, exec, hyprshot -z -m region"

        # Lock
        "$mainMod, L, exec, noctalia-shell ipc call lockScreen lock"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };

  # Clipboard manager
  services.cliphist = {
    enable = true;
    systemdTargets = [ "hyprland-session.target" ];
  };

  # USB automount
  services.udiskie = {
    enable = true;
    tray = "always";
    automount = true;
  };
}
