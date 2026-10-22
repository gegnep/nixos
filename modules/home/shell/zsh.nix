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
      updt-flake = "(cd ~/dev/harness && git pull --rebase --autostash) && (cd ~/nixos && git pull --rebase --autostash)";
      updt-flake-local = "(cd ~/nixos && nix flake update && git add flake.lock)";
      flake-check = "git add --intent-to-add -A . && nix flake check";

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
      catpn = "bat --plain --paging=never";
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
      ''
        eval "$(${pkgs.gh}/bin/gh completion -s zsh)"
      ''
      (lib.mkAfter ''
        # ghost text -> this session only (atuin's autosuggest ignores filter_mode: atuinsh/atuin#1618)
        _zsh_autosuggest_strategy_atuin() {
          # silence errors, since we don't want to spam the terminal prompt while typing.
          suggestion=$(ATUIN_QUERY="$1" atuin search --cmd-only --limit 1 --search-mode prefix --filter-mode session 2>/dev/null)
        }
        command_not_found_handler() {
          local pkgs
          pkgs=$(nix-locate --minimal --no-group --type x --type s --whole-name --at-root "/bin/$1")
          if [[ -n $pkgs ]]; then
            >&2 printf '%s is provided by:\n%s\nrun once with: , %s\n' "$1" "$pkgs" "$1"
          else
            >&2 printf 'zsh: command not found: %s\n' "$1"
          fi
          return 127
        }
        git-new() {
          local name=$1; shift
          local url
          url=$(ssh homelab git-new "$name" "$@") || return
          git remote add homelab "$url"
          git push -u homelab main
          echo "→ http://git.homelab/''${name}"
        }
        # ai: the model CLI on homelab (ai) and sidecar (ai-sc), from the desktops.
        # (q) quotes each arg for the remote zsh, so globs like
        # --from 'repo:*-Q8_0.gguf' survive. -t: bare `ai` opens its menu.
        # Skipped where ai is installed: nixos-prod imports this file on the
        # servers, and the function would shadow the real ai there.
        if (( ! $+commands[ai] )); then
          ai() { ssh -t homelab "ai ''${(q)@}" }
          ai-sc() { ssh -t sidecar "ai ''${(q)@}" }
        fi
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
