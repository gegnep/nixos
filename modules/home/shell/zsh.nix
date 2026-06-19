{ config, pkgs, ... }:

{
  catppuccin.zsh-syntax-highlighting.enable = true;
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = false;
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

      cat = "bat";
      catp = "bat --plain";
      catn = "bat --paging=never";
      cata = "bat --show-all";
    };

    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "zsh-autocomplete";
        src = pkgs.zsh-autocomplete;
        file = "share/zsh-autocomplete/zsh-autocomplete.plugin.zsh";
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = ''
      source ${./.p10k.zsh}
    '';
  };
}
