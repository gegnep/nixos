{ pkgs, ... }:

let
  slack-wrapped = pkgs.mkBwrapper {
    imports = [ pkgs.bwrapperPresets.desktop ];
    app = {
      package = pkgs.slack;
      runScript = "slack";
      execArgs = "-s %U --no-sandbox --enable-features=WebRTCPipeWireCapturer --ozone-platform=wayland";
    };
    mounts.readWrite = [ "$HOME/Downloads" ];
    dbus.system.talks = [
      "org.freedesktop.UPower"
      "org.freedesktop.login1"
    ];
    dbus.session.talks = [
      "org.freedesktop.Notifications"
      "org.freedesktop.ScreenSaver"
      "org.freedesktop.secrets"
    ];
  };

  vesktop-wrapped = pkgs.mkBwrapper {
    imports = [ pkgs.bwrapperPresets.desktop ];
    app = {
      # withSystemVencord now defaults to false upstream; old override dropped.
      # catppuccin is a one-time Vencord toggle (persists in ~/.bwrapper/vesktop/)
      package = pkgs.vesktop;
      runScript = "vesktop";
      execArgs = "--no-sandbox --enable-features=WebRTCPipeWireCapturer --ozone-platform=wayland";
    };
    mounts.readWrite = [ "$HOME/Downloads" ];
    dbus.session.talks = [
      "org.freedesktop.Notifications"
      "org.freedesktop.ScreenSaver"
      "org.freedesktop.secrets"
    ];
  };
in
{
  home.packages = with pkgs; [
    chatterino7
    zoom-us
    vesktop-wrapped
    slack-wrapped
  ];
}
