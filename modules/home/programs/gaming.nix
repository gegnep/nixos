{ pkgs, ... }:

{
  home.packages = with pkgs; [
    steam-run
    protonup-rs
    gamescope
    gamemode

    # Mod Managers
    gale
    deadlock-mod-manager
  ];

  programs.mangohud = {
    enable = true;
    settings = {
      gpu_temp = true;
      cpu_temp = true;
      fps = true;
      frametime = true;
      vulkan_driver = true;
    };
  };
}
