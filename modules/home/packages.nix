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
    libreoffice-fresh
    gimp-with-plugins

    # IDE and such
    vscodium
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
