{ pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./cli.nix
    ./firefox.nix
    ./git.nix
    ./gaming.nix
    ./obs.nix
    ./spotify.nix
    ./terminals.nix
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    chatterino7
    ungoogled-chromium
    davinci-resolve
    wootility
    gimp-with-plugins
    #teams-for-linux
  ];
}
