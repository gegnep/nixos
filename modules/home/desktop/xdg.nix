{ pkgs, config, ... }:

{
  xdg = {
    enable = true;
    mime.enable = true;

    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = [ "hyprland" "gtk" ];
        hyprland.default = [ "hyprland" "gtk" ];
      };
      extraPortals = [ 
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    userDirs = {
      enable = true;
      createDirectories = true;
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
        "default-web-brower" = "firefox.desktop";
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
        "inode/directory"= "dolphin.desktop";

        # email
        "x-scheme-handler/mailto" = "thunderbird.desktop";
        "message/rfc822" = "thunderbird.desktop";
      };
    };
  };
}
