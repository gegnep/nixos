{ pkgs, inputs, ... }:

let
  discord-moonlight = pkgs.discord.override {
    withMoonlight = true;
    moonlight = inputs.moonlight.packages.${pkgs.system}.moonlight;
  };

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

  discord-wrapped = pkgs.mkBwrapper {
    imports = [ pkgs.bwrapperPresets.desktop ];
    app = {
      package = discord-moonlight;
      runScript = "discord";
      execArgs = "--no-sandbox --enable-features=WebRTCPipeWireCapturer --ozone-platform=wayland";
    };
    mounts.readWrite = [
      "$HOME/Downloads"
      "$HOME/.config/moonlight-mod"
    ];
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
    discord-wrapped
    slack-wrapped
  ];

  programs.moonlight = {
    enable = true;
    configs.stable = {
      repositories = [ "https://moonlight-mod.github.io/extensions-dist/repo.json" ];
      extensions = {
        # builtins, relist or dropped
        moonbase = true;
        disableSentry = true;
        noTrack = true;
        noHideToken = true;

        # QoL
        clearUrls = true;
        betterCodeblocks = true;
        unindent = true;
        betterEmbedsYT = true;
        mediaTweaks = true;
        imageViewer = true;
        copyWebp = true;
        noNitroUpsell = true;
        noRpc = true;
        keybindTweaks = true;
        memberCount = true;

        # Declarative themeing
        "moonlight-css" = {
          enabled = true;
          config = {
            paths = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha-lavender.theme.css" ];
            themeAttributes = true;
          };
        };
      };
    };
  };
}
