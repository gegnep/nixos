{ ... }:

{
  programs.bat = {
    enable = true;
    config = {
      style = "numbers,changes,header";
      pager = "less -FR";
      map-syntax = [
        "*.ino:C++"
        "*.conf:INI"
      ];
    };
  };
  catppuccin.bat.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      theme_background = false;
    };
  };
  catppuccin.btop.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--time-style=relative"
    ];
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "~/.config/fastfetch/nixos.txt";
        type = "file";
        padding = {
          top = 1;
          left = 4;
          right = 2;
        };
        color = {
          "1" = "38;2;180;190;254"; # lavender  — top-left arm
          "2" = "38;2;137;180;250"; # blue      — top-right arm
          "3" = "38;2;116;199;236"; # sapphire  — right arm
          "4" = "38;2;148;226;213"; # teal      — bottom-center arm
          "5" = "38;2;245;194;231"; # pink      - bottom-left arm
          "6" = "38;2;203;166;247"; # mauve     — bottom-right arm
        };
      };

      display = {
        separator = "  ";
      };

      modules = [
        {
          type = "title";
          outputColor = "38;2;180;190;254";
        }
        "separator"

        # ── system ─────────────────────────────
        {
          type = "os";
          key = "{icon}  os";
          keyColor = "38;2;180;190;254";
          keyWidth = 12;
        }
        {
          type = "kernel";
          key = "{icon}  kern";
          keyColor = "38;2;180;190;254";
          keyWidth = 12;
        }
        {
          type = "packages";
          key = "{icon}  pkgs";
          keyColor = "38;2;180;190;254";
          keyWidth = 12;
        }
        {
          type = "uptime";
          key = "{icon}  up";
          keyColor = "38;2;180;190;254";
          keyWidth = 12;
        }
        "break"

        # ── environment ────────────────────────
        {
          type = "wm";
          key = "{icon}  wm";
          keyColor = "38;2;203;166;247";
          keyWidth = 12;
        }
        {
          type = "shell";
          key = "{icon}  sh";
          keyColor = "38;2;203;166;247";
          keyWidth = 12;
        }
        {
          type = "terminal";
          key = "{icon}  term";
          keyColor = "38;2;203;166;247";
          keyWidth = 12;
        }
        {
          type = "custom";
          key = "󰏘  theme";
          keyColor = "38;2;203;166;247";
          keyWidth = 12;
          format = "Catppuccin Mocha Lavender";
        }
        "break"

        # ── hardware ───────────────────────────
        {
          type = "cpu";
          key = "{icon}  cpu";
          keyColor = "38;2;137;180;250";
          keyWidth = 12;
        }
        {
          type = "gpu";
          key = "{icon}  gpu";
          keyColor = "38;2;137;180;250";
          keyWidth = 12;
        }
        {
          type = "memory";
          key = "{icon}  mem";
          keyColor = "38;2;137;180;250";
          keyWidth = 12;
        }
        {
          type = "disk";
          key = "{icon}  disk";
          keyColor = "38;2;137;180;250";
          keyWidth = 12;
          dirs = [
            "/"
            "~/xtra-stor"
          ];
        }
        "break"
        "break"
        {
          type = "colors";
          paddingLeft = 12;
          symbol = "block";
          block = {
            width = 3;
            range = {
              start = 0;
              end = 7;
            };
          };
        }
      ];
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  catppuccin.fzf.enable = true;

  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto-safe";
      vo = "gpu-next";
      profile = "high-quality";
    };
  };

  programs.nnn = {
    enable = true;
    bookmarks = {
      d = "~/downloads";
      p = "~/pictures";
      n = "~/nixos";
    };
  };

  programs.yt-dlp = {
    enable = true;
    settings = {
      format = "bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio/best";
      merge-output-format = "mp4";
      embed-thumbnail = true;
      embed-metadata = true;
      embed-chapters = true;
      embed-subs = true;
      sub-langs = "en.*";
      write-auto-subgs = true;
      output = "~/videos/yt-dlp/%(uploader)s/%(title)s.%(ext)s";
      concurrent-fragments = 4;
      download-archive = "~/.local/share/yt-dlp/archive.txt";
      progress = true;
      color = "auto";
    };
  };

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
    };
  };
  catppuccin.zathura.enable = true;
}
