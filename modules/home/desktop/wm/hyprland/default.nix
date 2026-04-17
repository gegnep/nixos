{
  pkgs,
  hostOptions,
  lib,
  ...
}:

let
  mkMonitorLine =
    m:
    "${m.name}, "
    + "${toString m.width}x${toString m.height}@${toString m.refresh}, "
    + "${toString m.x}x${toString m.y}, "
    + "${toString m.scale}"
    + lib.optionalString m.vrr ", vrr, 3";
in
{
  imports = [ ./binds.nix ];

  home.packages = with pkgs; [
    hyprpolkitagent
    hyprshot
  ];

  systemd.user.services = {
    hyprpolkitagent = {
      Unit = {
        Description = "Hyprland Polkit Agent";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "hyprland-session.target" ];
    };
  };

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
      "$flamingo" = "0xfff2cdcd";
      "$pink" = "0xfff5c2e7";
      "$mauve" = "0xffcba6f7";
      "$red" = "0xfff38ba8";
      "$maroon" = "0xffeba0ac";
      "$peach" = "0xfffab387";
      "$green" = "0xffa6e3a1";
      "$teal" = "0xff94e2d5";
      "$sky" = "0xff89dceb";
      "$sapphire" = "0xff74c7ec";
      "$blue" = "0xff89b4fa";
      "$lavender" = "0xffb4befe";
      "$text" = "0xffcdd6f4";
      "$subtext1" = "0xffbac2de";
      "$subtext2" = "0xffa6adc8";
      "$overlay2" = "0xff9399b2";
      "$overlay1" = "0xff7f849c";
      "$overlay0" = "0xff6c7086";
      "$surface2" = "0xff585b70";
      "$surface1" = "0xff45475a";
      "$surface0" = "0xff313244";
      "$base" = "0xff1e1e2e";
      "$mantle" = "0xff181825";
      "$crust" = "0xff11111b";

      # Monitors
      monitor = map mkMonitorLine hostOptions.desktop.monitors;

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
        sensitivity = 0;
        accel_profile = "flat";
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
        "noctalia-shell"
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
    };
  };
}
