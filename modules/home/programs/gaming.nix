{
  pkgs,
  lib,
  hostOptions,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      (pkgs.symlinkJoin {
        name = "prismlauncher";
        paths = [
          (prismlauncher.override {
            additionalPrograms = [ ffmpeg ];
            jdks = [
              graalvmPackages.graalvm-ce
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
    ]
    ++ lib.optionals hostOptions.features.gaming [
      steam-run
      protonup-rs
      gamescope
      gamemode

      # Mod Managers
      gale # thunderstore
      deadlock-mod-manager # gamebanana -> deadlock
      ckan # comprehensive kerbal archive network
    ];

  programs.mangohud = lib.mkIf hostOptions.features.gaming {
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
