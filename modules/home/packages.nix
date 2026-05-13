{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI tools
    fastfetch
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
    vesktop
    vscodium

    # General GUI utilities
    imv
    ventoy-full

    # Misc
    cowsay
    desktop-file-utils
    cabextract
  ];
}
