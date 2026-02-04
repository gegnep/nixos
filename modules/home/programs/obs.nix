{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libva
    libva-utils
    libva-vdpau-driver
    libvdpau
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      input-overlay
      obs-markdown
      obs-pipewire-audio-capture
      obs-vaapi
    ];
  };
}
