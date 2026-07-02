{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
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
      # subshells so the aliases don't strand the shell in ~/nixos
      nh-switch = "(cd ~/nixos && git add . && nh os switch)";
      nh-boot = "(cd ~/nixos && git add . && nh os boot)";
      updt-flake = "(cd ~/nixos && nix flake update && git add flake.lock)";
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

    initContent = lib.mkMerge [
      ''
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=#a6e3a1,fg=#1e1e2e,bold"
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="bg=#f38ba8,fg=#1e1e2e,bold"
        source ${./.p10k.zsh}
      ''
      (lib.mkAfter ''
        # ghost text -> this session only (atuin's autosuggest ignores filter_mode: atuinsh/atuin#1618)
        _zsh_autosuggest_strategy_atuin() {
          # silence errors, since we don't want to spam the terminal prompt while typing.
          suggestion=$(ATUIN_QUERY="$1" atuin search --cmd-only --limit 1 --search-mode prefix --filter-mode session 2>/dev/null)
        }
      '')
    ];
  };

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      sync_address = "http://atuin.homelab";
      auto_sync = true;
      sync_frequency = "5m";
      search_mode = "fuzzy";
      filter_mode = "host";
      workspaces = true;
      key_path = osConfig.sops.secrets.atuin-key.path;
    };
  };
}
