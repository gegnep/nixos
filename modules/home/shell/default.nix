{ pkgs, ... }:

{
  imports = [
    ./zsh.nix
  ];

  home.file.".p10k.zsh".source = ./.p10k.zsh;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "neovide";

    HYPRSHOT_DIR = "$HOME/pictures/screenshots";
    NIXOS_OZONE_WL = "1";
    BROWSER = "firefox";
    XDG_DATA_DIRS = "/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "Host *" = {
        AddKeysToAgent = "yes";
        SetEnv = {
          TERM = "xterm-256color";
        };
      };
    };
  };
}
