{ config, pkgs, ... }:

{
  catppuccin.zsh-syntax-highlighting.enable = true;
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

      cat = "bat";
      catp = "bat --plain";
      catn = "bat --paging=never";
      cata = "bat --show-all";
    };

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = ''
      HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=#a6e3a1,fg=#1e1e2e,bold"
      HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="bg=#f38ba8,fg=#1e1e2e,bold"
      source ${./.p10k.zsh}
    '';
  };
}
