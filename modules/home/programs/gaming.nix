{ pkgs, ... }:

{
  home.packages = with pkgs; [
    r2modman
    protonup-rs
    steam-run
    deadlock-mod-manager

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
}
