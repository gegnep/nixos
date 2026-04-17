{ pkgs, ... }:

{
  home.packages = with pkgs; [
    packwiz
    jdk17
    jemalloc

    (pkgs.waywall.overrideAttrs (old: {
      version = "unstable-2026-02-25";
      src = pkgs.fetchFromGitHub {
        owner = "tesselslate";
        repo = "waywall";
        rev = "main";
        hash = "sha256-3hFUCebsP4b6UHUi0tZpSTBhE1Ias8WpuZySKRcHPRo=";
      };
    }))
    xsel
    wl-clipboard

    (pkgs.buildFHSEnv {
      name = "ninbot";
      targetPkgs =
        p: with p; [
          jdk17
          libXt
          libxkbcommon
          libX11
          libXext
        ];
      runScript = "${pkgs.jdk17}/bin/java -Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=javax.swing.plaf.metal.MetalLookAndFeel -Djava.awt.headless=false -jar";
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
