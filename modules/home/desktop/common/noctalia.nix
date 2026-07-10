{ inputs, pkgs, ... }:

{
  programs.noctalia = {
    enable = true;
    package = (
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ../../../../patches/noctalia/0001-feat-plugin-ui-add-input-submitOnEnter-prop-for-chat.patch
          ../../../../patches/noctalia/0002-feat-plugin-ui-add-scroll-stickToBottom-onScroll-and.patch
          ../../../../patches/noctalia/0003-feat-plugin-ui-register-markdown-node-type-backed-by.patch
          ../../../../patches/noctalia/0004-fix-plugins-reclaim-stream-slots-when-the-process-ex.patch
          ../../../../patches/noctalia/0005-fix-ui-measure-MarkdownView-with-wrapped-label-sizes.patch
          ../../../../patches/noctalia/0006-feat-plugins-expose-barWidget.outputName-to-bar-widg.patch
        ];
      })
    );
    systemd.enable = true;

    settings = {
      backdrop = {
        enabled = true;
        blur_intensity = 0.5;
        tint_intensity = 0.3;
      };

      bar.default = {
        background_opacity = 0.0;
        capsule = true;
        start = [
          "group:g1"
          "workspaces"
          "media"
        ];
        center = [ "active_window" ];
        end = [
          "tray"
          "notifications"
          "network"
          "bluetooth"
          "volume"
          "clock"
          "weather"
          "control-center"
        ];
        font_family = "Hack Nerd Font Mono";
        margin_edge = 4;
        margin_ends = 8;
        padding = 8;
        shadow = false;
        thickness = 24;
        widget_spacing = 8;
        capsule_group = {
          fill = "surface_variant";
          id = "g1";
          members = [
            "temp"
            "cpu"
            "ram"
          ];
          opacity = 1.0;
          padding = 6.0;
        };
      };

      control_center = {
        sidebar = "full";
        sidebar_section = "full";
        width = "1024";
      };

      desktop_widgets.enabled = false;

      ide.pre_action_fade_seconds = false;

      location.auto_locate = true;

      lockscreen_widgets.enabled = false;

      notification.background_opacity = 0.8;

      osd.background_opacity = 0.8;

      shell = {
        font_family = "Hack Nerd Font";
        screen_time_enabled = true;
        telemetry_enabled = true;
        time_format = "{:%H:%M %a, %b $d}";
        launch_apps_as_systemd_services = true;
        launcher.compact = true;
        panel.transparency_mode = "glass";
        shadow.directon = "down_right";
      };

      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        directory = "/home/pengeg/pictures/wallpapers";
        default.path = "/home/pengeg/pictures/wallpapers/art002e009287~large.jpg";
      };

      widget = {
        active_window = {
          max_length = 256;
          min_length = 32;
          show_empty_label = true;
          title_scroll = "on_hover";
        };

        clock = {
          format = "{:%H:%M:%S}";
        };

        control-center = {
          custom_image = "/home/pengeg/pictures/Nix_snowflake.svg.png";
          glyph = "";
        };

        cpu = {
          show_label = false;
        };

        ram = {
          show_label = false;
        };

        temp = {
          show_label = false;
        };

        network = {
          show_label = false;
        };

        media = {
          max_length = 196;
          min_length = 32;
          title_scroll = "on_hover";
        };

        tray = {
          detached_panel = true;
          drawer = true;
        };

        volume = {
          show_label = true;
        };

        weather = {
          show_condition = false;
        };

        workspaces = {
          display = "none";
          hide_when_empty = true;
          occupied_color = "tertiary";
        };
      };
    };
  };
}
