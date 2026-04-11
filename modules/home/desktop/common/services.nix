{ pkgs, inputs, ... }:

{
  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      }/bin/noctalia-shell";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

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
