{
  pkgs,
  lib,
  hostOptions,
  ...
}:

{
  imports = [
    ./chat.nix
    ./claude.nix
    ./cli.nix
    ./fastfetch
    ./firefox.nix
    ./git.nix
    ./kiro.nix
    ./neovim.nix
    ./opencode.nix
    ./rustypaste.nix
    ./spotify.nix
    ./terminals.nix
    ./zed.nix
  ]
  ++ lib.optional hostOptions.features.audioProduction ./audio.nix
  ++ lib.optional hostOptions.features.gaming ./gaming.nix
  ++ lib.optional hostOptions.features.streaming ./obs.nix
  ++ lib.optional (hostOptions.hardware.form == "laptop") ./laptop.nix;

  home.packages =
    with pkgs;
    [ ]
    ++ lib.optionals hostOptions.features.streaming [ davinci-resolve ]
    ++ lib.optionals hostOptions.hardware.peripherals.wooting [ wootility ];
}
