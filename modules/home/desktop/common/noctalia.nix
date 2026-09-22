{
  inputs,
  lib,
  pkgs,
  hostOptions,
  ...
}:

let
  primaryMonitor = lib.findFirst (m: m.primary) null hostOptions.desktop.monitors;
  onPrimary = lib.optionalAttrs (primaryMonitor != null) { monitors = [ primaryMonitor.name ]; };

  loginBoxId = m: "lockscreen-login-box@${m.name}";
  loginBox = m: rec {
    box_height = 196.0;
    box_width = 720.0;
    placement_width = m.width / m.scale;
    placement_height = m.height / m.scale;
    cx = placement_width / 2;
    cy = placement_height - 119;
    output = m.name;
    rotation = 0.0;
    type = "login_box";
    settings = {
      background_color = "surface_variant";
      background_opacity = 0.88;
      background_radius = 12.0;
      input_opacity = 1.0;
      input_radius = 6.0;
      layout = "regular";
      show_caps_lock = true;
      show_keyboard_layout = true;
      show_login_button = true;
      show_media = true;
      show_session_buttons = true;
      show_unlock_hint = true;
      show_weather = true;
    };
  };
in
{
  # Disable HM built-in
  disabledModules = [ "programs/noctalia.nix" ];

  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd.enable = true;

    # Reconciled from `noctalia config export merged` 2026-09-21.
    # Runtime state (wallpaper.last, wallpaper.monitors.*) intentionally
    # excluded, noctalia writes those to the state dir at runtime.
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
          "taskbar"
          "taskbar_2"
          "group:g3"
        ];
        center = [ "active_window" ];
        end = [
          "group:g2"
          "clock"
          "weather"
          "control-center"
        ];
        font_family = "Hack Nerd Font Mono";
        margin_edge = 4;
        margin_ends = 8;
        padding = 8;
        shadow = false;
        thickness = 26;
        widget_spacing = 8;
        capsule_group = [
          {
            enabled = true;
            fill = "surface_variant";
            id = "g1";
            members = [
              "temp"
              "cpu"
              "ram"
            ];
            opacity = 1.0;
            padding = 6.0;
          }
          {
            border = "";
            enabled = true;
            fill = "surface_variant";
            id = "g2";
            members = [
              "tray"
              "notifications"
              "network"
              "bluetooth"
              "volume"
              "nix-monitor"
            ];
            opacity = 1.0;
            padding = 6.0;
          }
          {
            enabled = true;
            fill = "surface_variant";
            id = "g3";
            members = [
              "media"
              "audio_visualizer"
            ];
            opacity = 1.0;
            padding = 6.0;
          }
        ];
      };

      calendar = {
        enabled = true;
        account.personal_google = {
          color = "primary";
          name = "Personal Calendar";
          type = "google";
        };
      };

      control_center = {
        sidebar = "compact";
        sidebar_section = "none";
        width = 770;
        shortcuts = [
          { type = "wifi"; }
          { type = "bluetooth"; }
          { type = "caffeine"; }
          { type = "nightlight"; }
          { type = "audio"; }
          { type = "clipboard"; }
        ];
      };

      desktop_widgets.enabled = false;

      idle.pre_action_fade_seconds = 0;

      location.auto_locate = true;

      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = map loginBoxId hostOptions.desktop.monitors;
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = lib.listToAttrs (
          map (m: lib.nameValuePair (loginBoxId m) (loginBox m)) hostOptions.desktop.monitors
        );
      };

      notification = {
        background_opacity = 0.8;
        filter_order = [
          "filter"
          "filter-2"
          "filter-3"
        ];
        filter = {
          filter = {
            allow_permanent = false;
            bypass_dnd = false;
            enabled = true;
            match = "slack";
            play_sound = false;
            save_history = false;
            show_toast = true;
          };
          "filter-2" = {
            allow_permanent = false;
            bypass_dnd = false;
            enabled = true;
            match = "zoom";
            play_sound = false;
            save_history = false;
            show_toast = true;
          };
          "filter-3" = {
            allow_permanent = false;
            bypass_dnd = false;
            enabled = true;
            match = "thunderbird";
            play_sound = false;
            save_history = false;
            show_toast = false;
          };
        };
      }
      // onPrimary;

      osd = {
        background_opacity = 0.8;
        orientation = "vertical";
        position_vertical = "center_right";
      }
      // onPrimary;

      plugin_settings = {
        "avivbintangaringga/nix-monitor" = {
          clean_command = "";
          hide_clean_button = true;
          hide_optimize_button = true;
          hide_update_button = true;
          panel_placement = "floating";
          panel_position = "auto";
          show_update_available_notification = false;
          update_command = "";
        };
        "gegnep/claude-launcher" = {
          allow_tools = true;
          chat_placement = "floating";
          effort = "high";
          model = "claude-sonnet-5";
          models = [
            "claude-fable-5-1"
            "claude-opus-5"
            "claude-sonnet-5"
            "haiku"
          ];
          transcripts_dir = "~/.claude-personal/projects/-home-pengeg--local-state-noctalia-claude-launcher-workspace";
        };
      };

      plugins = {
        enabled = [
          "noctalia/kaomoji"
          "avivbintangaringga/nix-monitor"
          "gegnep/niri-taskbar"
          "gegnep/claude-launcher"
        ];
        source = [
          {
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            name = "official";
          }
          {
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
            name = "community";
          }
          {
            kind = "path";
            location = "/home/pengeg/dev/noctalia/noctalia-plugins";
            name = "dev";
          }
        ];
      };

      shell = {
        avatar_path = "/home/pengeg/pictures/ChudAlert.gif";
        font_family = "Hack Nerd Font";
        launch_apps_as_systemd_services = true;
        screen_time_enabled = true;
        telemetry_enabled = true;
        time_format = "{:%H:%M:%S}";
        launcher.compact = true;
        panel = {
          control_center_placement = "floating";
          open_near_click_control_center = true;
          open_near_click_launcher = true;
          open_near_click_wallpaper = true;
          session_placement = "floating";
          session_position = "center";
          transparency_mode = "glass";
          wallpaper_placement = "floating";
        };
        shadow.direction = "down_right";
      };

      theme = {
        mode = "dark";
        source = "community";
        builtin = "Catppuccin";
        community_palette = "Catppuccin Lavender";
        wallpaper_scheme = "m3-content";
      };

      wallpaper = {
        enabled = true;
        directory = "/home/pengeg/pictures/wallpapers";
        default.path = "/home/pengeg/pictures/wallpapers/art002e009287~large.jpg";
        favorite = [
          {
            path = "/home/pengeg/pictures/wallpapers/art002e000190~large.jpg";
            theme_mode = "auto";
          }
          {
            path = "/home/pengeg/pictures/wallpapers/art002e009287~large.jpg";
            theme_mode = "auto";
          }
          {
            path = "/home/pengeg/pictures/wallpapers/art002e009301~large.jpg";
            theme_mode = "auto";
          }
          {
            community_palette = "Catppuccin Mocha Lavender";
            palette_source = "community";
            path = "/home/pengeg/pictures/wallpapers/HOlk_4pW8AAmJrU.jpg";
            theme_mode = "dark";
          }
        ];
      };

      weather.refresh_minutes = 15;

      widget = {
        active_window = {
          enabled = true;
          max_length = 256;
          min_length = 32;
          show_empty_label = true;
          title_scroll = "on_hover";
        };

        audio_visualizer = {
          bands = 32;
          color_2 = "secondary";
          mirrored = false;
          width = 96;
        };

        clock.format = "{:%H:%M %a, %b %d}";

        control-center = {
          custom_image = "/home/pengeg/pictures/Nix_snowflake.svg.png";
          glyph = "";
        };

        cpu.show_value = false;

        media = {
          album_art_only = true;
          hide_artist = true;
          max_length = 160;
          min_length = 96;
          title_scroll = "on_hover";
        };

        network.show_label = false;

        nix-monitor = {
          checking_color = "tertiary";
          show_text = false;
          type = "avivbintangaringga/nix-monitor:nix-monitor";
          up_to_date_color = "primary";
          update_available_color = "error";
        };

        privacy.active_color = "secondary";

        ram.show_value = false;

        taskbar_2 = {
          display = "none";
          show_empty_workspaces = false;
          type = "gegnep/niri-taskbar:taskbar";
        };

        temp.show_value = false;

        tray = {
          detached_panel = true;
          drawer = true;
        };

        weather = {
          max_length = 196;
          show_condition = false;
        };
      };
    };
  };
}
