{ pkgs, ... }:

{
  home.packages = with pkgs; [
    steam-run
    protonup-rs
    mangohud
    gamescope
    gamemode

    # Mod Managers
    r2modman
    deadlock-mod-manager

    # Minecraft
    jdk17
    jemalloc
    waywall

    (pkgs.buildFHSEnv {
      name = "ninbot";
      targetPkgs = p: with p; [
        jdk17
        libXt
        libxkbcommon
        libX11
        libXext
      ];
      runScript = "${pkgs.jdk17}/bin/java -Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=javax.swing.plaf.metal.MetalLookAndFeel -jar";
     })

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
  ];

  home.file.".config/waywall" = {
    source = ./waywall;
    recursive = true;
  };
}
