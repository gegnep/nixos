{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    sudo
    nix-alien
  ];

  # nix-ld for running unpatched binaries
  programs.nix-ld.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  fonts.packages = with pkgs; [
    fira-sans
    roboto
    jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    material-symbols
    material-icons
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    nerd-fonts.hack
  ];
}
