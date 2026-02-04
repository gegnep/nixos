{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI tools
    neofetch
    nnn
    tldr
    ripgrep
    jq
    eza
    fzf
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    xdg-utils

    # Nix tools
    nix-output-monitor

    # Archiving
    zip
    unzip
    xz
    p7zip

    # System monitoring
    btop
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
    firefox
    keepassxc
    syncthing
    discord
    vscodium
    ventoy-full

    # Misc
    cowsay
    desktop-file-utils
    cabextract
    appimage-run
  ];
}
