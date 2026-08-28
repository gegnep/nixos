{
  pkgs,
  lib,
  hostOptions,
  ...
}:

{
  imports = [
    ./agents.nix
    ./chat.nix
    ./cli.nix
    ./fastfetch
    ./firefox.nix
    ./git.nix
    ./kiro.nix
    ./neovim.nix
    ./rustypaste.nix
    ./spotify.nix
    ./terminals.nix
    ./thunderbird.nix
    ./zen.nix
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
