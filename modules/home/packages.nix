{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI tools
    tldr
    ripgrep
    jq
    file
    tree
    gnupg
    xdg-utils
    glow
    libsecret

    # Nix tools
    nix-output-monitor
    sops
    age

    # Archiving
    zip
    unzip
    p7zip
    peazip

    # System monitoring
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
