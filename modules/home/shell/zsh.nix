{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];

  programs.zsh = {
    enable = true;
    history.size = 1000;
    dotDir = "${config.xdg.configHome}/zsh";

    shellAliases = {
      ll = "ls -l";
      update = "nh os switch";
      shtdwn = "shutdown -h now";
      svim = "sudo -E nvim";
      claude-dev = "nix develop ~/dev-shell -c claude";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; }
        { name = "marlonrichert/zsh-autocomplete"; }
      ];
    };

    initContent = ''
      source ${./.p10k.zsh}

      # Auto-start Hyprland on tty2
      if [[ "$(tty)" == "/dev/tty2" ]] && [[ -z "$DISPLAY" ]] && [[ -z "$WAYLAND_DISPLAY" ]]; then
        exec start-hyprland
      fi
    '';
  };
}
