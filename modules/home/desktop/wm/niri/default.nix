{
  lib,
  hostOptions,
  ...
}:

let
  mkOutput = m: {
    output = {
      _args = [ m.name ];
      mode = "${toString m.width}x${toString m.height}@${toString m.refresh}";
      scale = m.scale;
      position._props = {
        x = m.x;
        y = m.y;
      };
    }
    // lib.optionalAttrs m.vrr {
      variable-refresh-rate = { };
    };
  };

  gradient = from: to: {
    _props = {
      angle = 135;
      inherit from to;
      "in" = "oklch shorter hue";
      relative-to = "window";
    };
  };
in
{
  imports = [ ./binds.nix ];

  wayland.windowManager.niri = {
    enable = true;
    # nixpkgs `programs.niri` (modules/nixos/wm/niri.nix) already installs the
    # session units system-wide; don't duplicate them in the user profile
    systemd.enable = false;
    # portals are handled at system scope (modules/nixos/desktop.nix) — a
    # user-level portal package would shadow the system portal files
    portalPackage = null;

    settings = {
      # Environment
      environment = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };

      # Input
      # NOTE: flag-only children (tap, dwt, middle-emulation, ...) must be
      # `{ }` (bare node), not `= true` — niri rejects arguments on them
      input = {
        keyboard.xkb.layout = "us";
        touchpad = {
          tap = { };
          dwt = { }; # disable-while-typing
          middle-emulation = { }; # three finger tap = middle click
          click-method = "clickfinger";
          accel-speed = 0.3;
          accel-profile = "adaptive";
          scroll-method = "two-finger";
          tap-button-map = "left-right-middle";
        };
        mouse = {
          accel-profile = "flat";
          accel-speed = 0.2;
        };
        tablet.map-to-output = "eDP-1";
        warp-mouse-to-focus = { };
        focus-follows-mouse._props.max-scroll-amount = "0%";
      };

      # Layout
      layout = {
        background-color = "transparent";
        gaps = 8;
        border = {
          on = { };
          width = 4;
          active-gradient = gradient "#cba6f7" "#89b4fa";
          inactive-gradient = gradient "#6c7086" "#45475a";
          urgent-gradient = gradient "#f38ba8" "#fab387";
        };
        focus-ring.off = { };
        preset-column-widths._children = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];
        default-column-width.proportion = 1.0 / 2.0;
        preset-window-heights._children = [
          { proportion = 1.0 / 5.0; }
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
        ];
      };

      # Background blur
      blur = {
        passes = 2;
        offset = 3.0;
        noise = 0.03;
        saturation = 1.25;
      };

      # Cursor
      cursor = {
        xcursor-theme = "phinger-cursors-light";
        xcursor-size = 36;
      };

      # Misc
      animations.on = { };
      prefer-no-csd = { }; # fix rounded corners
      screenshot-path = "~/pictures/screenshots/niri-%Y-%m-%d-%H-%M-%S.png";
      hotkey-overlay.skip-at-startup = true;

      # Ordered/repeated top-level nodes: outputs, rules, startup spawns
      _children =
        (map mkOutput hostOptions.desktop.monitors)

        # Window rules (order matters: later rules override earlier ones)
        ++ (map (r: { window-rule = r; }) [
          {
            geometry-corner-radius = [
              12.0
              12.0
              12.0
              12.0
            ];
            clip-to-geometry = true;
          }
          {
            match._props = {
              app-id = "^steam$";
              title = "^notificationtoasts_";
            };
            open-floating = true;
            open-focused = false;
            default-floating-position._props = {
              relative-to = "bottom-right";
              x = 12;
              y = 12;
            };
          }
          {
            match._props = {
              app-id = "^steam$";
              title = "^Friends List";
            };
            open-floating = true;
          }
          {
            match._props.app-id = "^com\\.mitchellh\\.ghostty$";
            opacity = 1.0;
          }
          {
            match._props = {
              app-id = "^firefox$";
              title = "^Picture-in-Picture$";
            };
            open-floating = true;
            default-floating-position._props = {
              relative-to = "top-right";
              x = 12;
              y = 12;
            };
          }
          {
            match._props.app-id = "^org\\.keepassxc\\.KeePassXC$";
            open-floating = true;
            block-out-from = "screen-capture";
          }
          {
            # blur behind terminals/neovide
            _children = [
              { match._props.app-id = "^com\\.mitchellh\\.ghostty$"; }
              { match._props.app-id = "^Alacritty$"; }
              { match._props.app-id = "^neovide$"; }
            ];
            background-effect = {
              blur = true;
              xray = true;
            };
          }
        ])

        # Layer rules
        ++ (map (r: { layer-rule = r; }) [
          {
            match._props.namespace = "^noctalia-backdrop";
            place-within-backdrop = true;
          }
          {
            # noctalia surfaces get real (non-xray) blur
            match._props.namespace = ''^noctalia-(bar-[^"]+|notification|dock|panel|attached-panel|osd)$'';
            background-effect.xray = false;
          }
        ])

        # Startup
        ++ (map (cmd: { spawn-at-startup = cmd; }) (
          [
            [
              "sh"
              "-c"
              "dbus-update-activation-environment --systemd --all && systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-gtk.service"
            ]
            [
              "sh"
              "-c"
              "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=niri NIRI_SOCKET XDG_SESSION_TYPE && systemctl --user restart xdg-desktop-portal.service"
            ]
            [ "noctalia" ]
          ]
          ++ lib.optionals (hostOptions.hardware.form == "laptop") [
            [
              "sh"
              "-c"
              "while ! busctl --user status org.gnome.Mutter.ScreenCast >/dev/null 2>&1; do sleep 0.2; done; systemctl --user restart xdg-desktop-portal-gnome.service"
            ]
          ]
        ));
    };
  };
}
