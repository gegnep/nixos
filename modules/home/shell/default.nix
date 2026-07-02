{ pkgs, ... }:

{
  imports = [
    ./zsh.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "zed";
    SOPS_EDITOR = "nvim -n -i NONE -u NORC";

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
        IdentityFile = "/run/secrets/ssh-key-personal";
        IdentitiesOnly = "yes";
        AddKeysToAgent = "yes";

        ControlMaster = "auto";
        ControlPath = "~/.ssh/sockets/%r@%h-%p";
        ControlPersist = "10m";

        ServerAliveInterval = 15;
        ServerAliveCountMax = 3;

        SetEnv = {
          TERM = "xterm-256color";
        };
      };

      "Host homelab" = {
        ConnectTimeout = 5;
      };
    };
  };
  home.file.".ssh/sockets/.keep".text = "";
}
