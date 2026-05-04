{ pkgs, ... }:

{
  home.packages = with pkgs; [
    packwiz
    jdk17
    jemalloc

    (pkgs.waywall.overrideAttrs (old: {
      version = "unstable-2026-05-04";
      src = pkgs.fetchFromGitHub {
        owner = "tesselslate";
        repo = "waywall";
        rev = "main";
        hash = "sha256-zE9VT/3/AEg0cJ8aE1fhERH8Gh1LeVL9nsC27Nre4hY=";
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
  ];

  home.file.".config/waywall" = {
    source = ./waywall;
    recursive = true;
  };
}
