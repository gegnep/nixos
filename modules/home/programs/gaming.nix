{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Prism with JDKs covering most modded MC versions
    # (8: <=1.16, 17: 1.17-1.20.4, 21: 1.20.5+), jemalloc for alloc perf
    (pkgs.symlinkJoin {
      name = "prismlauncher";
      paths = [
        (prismlauncher.override {
          additionalPrograms = [ ffmpeg ];
          jdks = [
            jdk21
            jdk17
            jdk8
          ];
        })
      ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/prismlauncher \
          --set LD_PRELOAD "${pkgs.jemalloc}/lib/libjemalloc.so"
      '';
    })
    packwiz

    steam-run
    protonup-rs
    gamescope

    # Mod Managers
    gale # thunderstore
    deadlock-mod-manager # gamebanana -> deadlock
    ckan # comprehensive kerbal archive network
    satisfactorymodmanager # ficsit.app
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
