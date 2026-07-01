{
  pkgs,
  lib,
  hostOptions,
  ...
}:

{
  imports = [
    ./cli.nix
    ./claude.nix
    ./chat.nix
    ./fastfetch
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
    [ ]
    ++ lib.optionals hostOptions.features.streaming [ davinci-resolve ]
    ++ lib.optionals hostOptions.hardware.peripherals.wooting [ wootility ];
}
