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
    file-roller

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

    # General GUI utilities
    imv
    ventoy-full
    seahorse

    # Misc
    prusa-slicer
    desktop-file-utils
    cabextract
  ];
}
