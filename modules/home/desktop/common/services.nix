{ pkgs, ... }:

{
  services.cliphist = {
    enable = true;
    systemdTargets = [ "graphical-session.target" ];
  };

  services.udiskie = {
    enable = true;
    tray = "always";
    automount = true;
  };
}
