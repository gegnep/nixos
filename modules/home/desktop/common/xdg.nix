{ config, ... }:

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
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
        "application/gzip" = "org.gnome.FileRoller.desktop";
        "application/x-gzip" = "org.gnome.FileRoller.desktop";
        "application/x-bzip2" = "org.gnome.FileRoller.desktop";
        "application/x-xz" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/x-rar-compressed" = "org.gnome.FileRoller.desktop";
        "application/vnd.rar" = "org.gnome.FileRoller.desktop";

        # text
        "text/plain" = "neovide.desktop";
        "text/x-script.python" = "neovide.desktop";
        "application/x-shellscript" = "neovide.desktop";
        "application/json" = "neovide.desktop";
        "application/xml" = "neovide.desktop";
        "text/xml" = "neovide.desktop";
        "text/x-c" = "neovide.desktop";
        "text/x-c++" = "neovide.desktop";
        "text/x-java" = "neovide.desktop";
        "text/x-rust" = "neovide.desktop";
        "text/x-go" = "neovide.desktop";
        "text/markdown" = "neovide.desktop";

        # files
        "inode/directory" = "org.gnome.Nautilus.desktop";

        # email (web-based)
        "x-scheme-handler/mailto" = "thunderbird.desktop";
      };
    };
  };
}
