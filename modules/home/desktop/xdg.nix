{ pkgs, ... }:

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

    mimeApps = {
      enable = true;
      defaultApplications = {
        "default-web-browser"       = [ "firefox.desktop" ];
        "text/html"                 = [ "firefox.desktop" ];
        "text/xml"                  = [ "firefox.desktop" ];
        "x-scheme-handler/http"     = [ "firefox.desktop" ];
        "x-scheme-handler/https"    = [ "firefox.desktop" ];
        "x-scheme-handler/about"    = [ "firefox.desktop" ];
        "x-scheme-handler/unknown"  = [ "firefox.desktop" ];
        "application/pdf"           = [ "firefox.desktop" ];
        "inode/directory"           = [ "pcmanfm.desktop" ];

      };
    };
  };
}
