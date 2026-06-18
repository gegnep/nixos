{
  pkgs,
  lib,
  hostOptions,
  ...
}:

{
  imports = [
    ./cli.nix
    ./firefox.nix
    ./git.nix
    ./neovim.nix
    ./spotify.nix
    ./terminals.nix
  ]
  ++ lib.optional hostOptions.features.audioProduction ./audio.nix
  ++ lib.optional (hostOptions.features.gaming || hostOptions.features.mcsr) ./gaming.nix
  ++ lib.optional hostOptions.features.mcsr ./mcsr.nix
  ++ lib.optional hostOptions.features.streaming ./obs.nix
  ++ lib.optional (hostOptions.hardware.form == "laptop") ./laptop.nix;

  home.packages =
    with pkgs;
    [
      chatterino7
      ungoogled-chromium
      gimp-with-plugins
      #teams-for-linux
      (pkgs.symlinkJoin {
        name = "slack-wayland";
        paths = [ pkgs.slack ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/slack \
            --add-flags "--enable-features=WebRTCPipeWireCapturer --ozone-platform-hint=auto"
        '';
      })
      kiro
    ]
    ++ lib.optionals hostOptions.features.streaming [ davinci-resolve ]
    ++ lib.optionals hostOptions.hardware.peripherals.wooting [ wootility ];
}
