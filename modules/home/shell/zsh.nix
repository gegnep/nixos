{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
      extended = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    autocd = true;
    defaultKeymap = "viins";

    shellAliases = {
      update = "nh os switch";
      shtdwn = "shutdown -h now";
      svim = "sudo -E nvim";
      yt-mp3 = "yt-dlp -x --audio-format mp3 --audio-quality 0 -o '%(title)s.%(ext)s'";

      ls = "eza";
      ll = "eza -l";
      la = "eza -a";
      lah = "eza -lah";
      l = "eza -lah";
      lt = "eza --tree";
      lta = "eza --tree -a";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        {
          name = "romkatv/powerlevel10k";
          tags = [
            "as:theme"
            "depth:1"
          ];
        }
        { name = "marlonrichert/zsh-autocomplete"; }
      ];
    };

    initContent = ''
      source ${./.p10k.zsh}
    '';
  };
}
