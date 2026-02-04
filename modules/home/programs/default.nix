{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./gaming.nix
    ./obs.nix
    ./audio.nix
    ./spotify.nix
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    chatterino7
    ungoogled-chromium
    davinci-resolve
    wootility
    gimp-with-plugins
  ];
}
