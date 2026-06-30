{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI tools
    tldr
    ripgrep
    jq
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    xdg-utils
    yt-dlp
    glow
    libsecret

    # Nix tools
    nix-output-monitor

    # Archiving
    zip
    unzip
    xz
    p7zip
    peazip

    # System monitoring
    radeontop
    iotop
    iftop
    strace
    lsof
    sysstat
    ethtool
    pciutils
    usbutils
    powertop

    # Networking
    mtr
    dnsutils
    nmap
    ipcalc

    # Desktop apps
    keepassxc
    vscodium
    (pkgs.vesktop.override {
      withSystemVencord = false;
    })
    libreoffice-fresh
    chatterino7
    gimp-with-plugins
    (pkgs.symlinkJoin {
      name = "slack-wayland";
      paths = [ pkgs.slack ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/slack \
          --add-flags "--enable-features=WebRTCPipeWireCapturer --ozone-platform-hint=auto"
      '';
    })
    kiro

    # General GUI utilities
    imv
    ventoy-full
    seahorse

    # Misc
    cowsay
    desktop-file-utils
    cabextract
  ];
}
