{ pkgs, ... }:

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

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      theme_background = false;
    };
  };

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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    historyWidget.zsh.command = "";
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto-safe";
      vo = "gpu-next";
      profile = "high-quality";
    };
  };

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

  programs.nnn = {
    enable = true;
    bookmarks = {
      d = "~/downloads";
      p = "~/pictures";
      n = "~/nixos";
    };
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    prefix = "C-a";
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    baseIndex = 0;
    escapeTime = 0;
    focusEvents = true;
    historyLimit = 10000;
    mouse = true;
    clock24 = true;
    disableConfirmationPrompt = true;

    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
      tmuxPlugins.prefix-highlight
    ];
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
      write-auto-subs = true;
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

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };
}
