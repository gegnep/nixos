{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI tools
    fastfetch
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
    lazygit

    # Nix tools
    nix-output-monitor

    # Archiving
    zip
    unzip
    xz
    p7zip
    peazip

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
    discord
    vscodium

    # General GUI utilities 
    feh
    imv
    mpv
    zathura
    ventoy-full

    # Misc
    cowsay
    desktop-file-utils
    cabextract
  ];
}
