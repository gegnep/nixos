{ pkgs, lib, ... }:

let
  vesktop-unwrapped = pkgs.vesktop.override { withSystemVencord = false; };

  slack-wrapped = pkgs.mkBwrapper {
    imports = [ pkgs.bwrapperPresets.desktop ];
    app = {
      package = pkgs.slack;
      runScript = "slack";
      execArgs = "-s %U --enable-features=WebRTCPipeWireCapturer --ozone-platform=wayland";
    };
    mounts.readWrite = [ "$HOME/Downloads" ];
    dbus.system.talks = [
      "org.desktop.UPower"
      "org.desktop.login1"
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
      package = vesktop-unwrapped;
      runScript = "vesktop";
      execArgs = "--enable-features=WebRTCPipeWireCapturer --ozone-platform=wayland";
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
    vesktop-wrapped
    slack-wrapped
  ];
}
