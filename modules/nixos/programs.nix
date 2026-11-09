{
  pkgs,
  lib,
  config,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # nix-ld for running unpatched binaries
  programs.nix-ld.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.steam = {
    enable = true;
    package = pkgs.steamWithMillennium;
    extraCompatPackages = lib.optionals config.mySystem.features.gaming (
      with pkgs;
      [
        proton-ge-bin
        proton-cachyos_x86_64_v3
        steamtinkerlaunch
        steam-play-none
      ]
    );
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.regionlock = {
    enable = true;
    persist = true;
    settings = {
      default_game = "deadlock";
    };
  };

  fonts.packages = with pkgs; [
    fira-sans
    roboto
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    material-symbols
    material-icons
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
  ];
}
