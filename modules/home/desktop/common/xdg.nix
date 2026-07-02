{ pkgs, config, ... }:

{
  xdg = {
    enable = true;
    mime.enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = false;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      publicShare = null;
      templates = null;
      videos = "${config.home.homeDirectory}/videos";
      extraConfig = {
        SCREENSHOTS = "${config.home.homeDirectory}/pictures/screenshots";
        WALLPAPERS = "${config.home.homeDirectory}/pictures/wallpapers";
      };
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        # web
        "default-web-browser" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";

        # pdf
        "application/pdf" = "zathura.desktop";

        # images
        "image/png" = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "image/webp" = "imv.desktop";
        "image/bmp" = "imv.desktop";
        "image/tiff" = "imv.desktop";
        "image/svg+xml" = "imv.desktop";

        # videos
        "video/mp4" = "mpv.desktop";
        "video/mkv" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/avi" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/x-msvideo" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop";

        # archives
        "application/zip" = "peazip.desktop";
        "application/x-tar" = "peazip.desktop";
        "application/gzip" = "peazip.desktop";
        "application/x-gzip" = "peazip.desktop";
        "application/x-bzip2" = "peazip.desktop";
        "application/x-xz" = "peazip.desktop";
        "application/x-7z-compressed" = "peazip.desktop";
        "application/x-rar-compressed" = "peazip.desktop";
        "application/vnd.rar" = "peazip.desktop";

        # text
        "text/plain" = "zed.desktop";
        "text/x-script.python" = "zed.desktop";
        "application/x-shellscript" = "zed.desktop";
        "application/json" = "zed.desktop";
        "application/xml" = "zed.desktop";
        "text/xml" = "zed.desktop";
        "text/x-c" = "zed.desktop";
        "text/x-c++" = "zed.desktop";
        "text/x-java" = "zed.desktop";
        "text/x-rust" = "zed.desktop";
        "text/x-go" = "zed.desktop";
        "text/markdown" = "zed.desktop";

        # files
        "inode/directory" = "dolphin.desktop";

        # email (web-based)
        "x-scheme-handler/mailto" = "firefox.desktop";
      };
    };
  };
}
