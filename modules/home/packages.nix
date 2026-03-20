{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI tools
    fastfetch
    nnn
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
    discord
    vscodium

    # General GUI utilities 
    feh
    imv
    ventoy-full

    # Misc
    cowsay
    desktop-file-utils
    cabextract
  ];
  
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto-safe";
      vo = "gpu-next";
      profile = "high-quality";
    };
  };

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
    };
  };
  catppuccin.zathura.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  catppuccin.fzf.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      theme_background = false;
    };
  };
  catppuccin.btop.enable = true;

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
