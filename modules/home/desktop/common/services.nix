{ pkgs, inputs, ... }:

{
  services.syncthing.enable = true;

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
