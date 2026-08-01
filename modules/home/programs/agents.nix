{
  pkgs,
  osConfig,
  config,
  ...
}:

let
  opencodeData = "$HOME/.bwrapper/opencode/data";
  opencodeGoKey = osConfig.sops.secrets.opencode-go-key.path;
  serverPort = 4096;

  # inner-PATH shim so claude can still use the opencode CLI directly
  opencode-unwrapped = pkgs.writeShellScriptBin "opencode" ''
    exec ${pkgs.opencode}/bin/opencode "$@"
  '';

  # claude <-> opencode-server bridge; self-documenting via `oc help`
  oc = pkgs.writeShellApplication {
    name = "oc";
    runtimeInputs = with pkgs; [
      curl
      jq
    ];
    text = ''
      base="http://127.0.0.1:${toString serverPort}"
      dir="''${OC_DIR:-$PWD}"
      q="directory=$(jq -rn --arg d "$dir" '$d|@uri')"

      # request wrapper: no -f, surfaces the JSON error body on non-2xx,
      # catches HTML-200s from wrong routes
      req() {
        method="$1"; path="$2"; data="''${3:-}"
        tmp=$(mktemp)
        if [ -n "$data" ]; then
          code=$(curl -s -o "$tmp" -w '%{http_code}' -X "$method" "$base$path" \
            -H 'Content-Type: application/json' -d "$data")
        else
          code=$(curl -s -o "$tmp" -w '%{http_code}' -X "$method" "$base$path")
        fi
        if [ "''${code#2}" = "$code" ]; then
          echo "oc: HTTP $code $method $path" >&2; cat "$tmp" >&2; echo >&2
          rm -f "$tmp"; return 1
        fi
        if [ "$(head -c1 "$tmp")" = "<" ]; then
          echo "oc: HTML response from $path (wrong route?)" >&2
          rm -f "$tmp"; return 1
        fi
        cat "$tmp"; rm -f "$tmp"
      }

      # variant vocab per provider; kimi takes none
      check_variant() {
        model="$1"; variant="$2"
        case "$model" in
          *kimi*) [ -z "$variant" ] || { echo "oc: kimi takes no variant" >&2; return 1; } ;;
          openai/*) case "$variant" in ""|low|medium|high|xhigh) ;; \
            *) echo "oc: bad variant '$variant' for $model" >&2; return 1;; esac ;;
          opencode-go/glm*|opencode/glm*) case "$variant" in ""|high|xhigh) ;; \
            *) echo "oc: bad variant '$variant' for $model" >&2; return 1;; esac ;;
        esac
      }

      # prompting a busy session KILLS its in-flight run (reproduced on
      # 1.18.9) — hard-refuse unless OC_FORCE=1
      busy_guard() {
        st=$(req GET "/session/status?$q" | jq -r --arg s "$1" '.[$s].type // "idle"')
        if [ "$st" != "idle" ] && [ "''${OC_FORCE:-0}" != "1" ]; then
          echo "oc: session $1 is $st — sending now kills the run. OC_FORCE=1 to override." >&2
          return 1
        fi
      }

      mkbody() { # prompt model variant agent
        jq -n --arg p "$1" --arg m "$2" --arg v "$3" --arg a "$4" \
          '{parts: [{type:"text", text:$p}],
            model: {providerID:($m|split("/")[0]), modelID:($m|sub("^[^/]+/";""))}}
           + (if $v != "" then {variant:$v} else {} end)
           + (if $a != "" then {agent:$a} else {} end)'
      }

      cmd="''${1:-help}"; shift || true
      case "$cmd" in
        new)
          [ -d "$dir" ] || { echo "oc: directory $dir does not exist" >&2; exit 1; }
          req POST "/session?$q" "{\"title\": \"''${1:-claude-spawned}\"}" | jq -r .id ;;
        ask)
          sid="''${1:?usage: oc ask <sid> <prompt> <provider/model> [variant] [agent]}"
          prompt="''${2:?missing prompt}"; model="''${3:?model is mandatory (no silent Go default)}"
          variant="''${4:-}"; agent="''${5:-}"
          check_variant "$model" "$variant"; busy_guard "$sid"
          req POST "/session/$sid/message?$q" "$(mkbody "$prompt" "$model" "$variant" "$agent")" \
            | jq -r '.parts[] | select(.type=="text") | .text' ;;
        async)
          sid="''${1:?usage: oc async <sid> <prompt> <provider/model> [variant]}"
          prompt="''${2:?missing prompt}"; model="''${3:?model is mandatory (no silent Go default)}"
          variant="''${4:-}"
          check_variant "$model" "$variant"; busy_guard "$sid"
          req POST "/session/$sid/prompt_async?$q" "$(mkbody "$prompt" "$model" "$variant" "")" ;;
        log)
          req GET "/session/''${1:?missing sid}/message?$q&limit=''${2:-20}" | jq -r '.[]
            | "[\(.info.role)] " + ([.parts[]
              | if .type=="text" then .text
                elif .type=="tool" then "<tool:\(.tool) \(.state.status // .state.type // "?")>"
                else empty end] | join("\n"))' ;;
        status)   req GET "/session/status?$q" | jq ;;
        sessions) req GET "/session?$q" | jq -r '.[] | .id + "  " + (.title // "-")' ;;
        abort)    req POST "/session/''${1:?missing sid}/abort?$q" ;;
        perms)    req GET "/permission?$q" | jq ;;
        reply)    req POST "/permission/''${1:?missing requestID}/reply?$q" \
                    "{\"reply\": \"''${2:?once|always|reject}\"}" ;;
        health)   req GET "/global/health" | jq ;;
        *)
          cat <<'EOF'
      oc new [title]                                  create session (binds to $PWD / $OC_DIR)
      oc ask <sid> <prompt> <model> [variant] [agent]  send, wait, print reply
      oc async <sid> <prompt> <model> [variant]        send, return immediately
      oc log <sid> [n]                                 transcript incl tool calls
      oc status | oc sessions | oc abort <sid>
      oc perms                                         pending permission requests
      oc reply <requestID> <once|allow|reject>         answer a permission request
      oc health
      OC_DIR overrides directory binding; OC_FORCE=1 overrides the busy guard.
      EOF
          ;;
      esac
    '';
  };

  mkClaudeSandboxed =
    name:
    pkgs.mkBwrapper {
      imports = [
        pkgs.bwrapperPresets.devshell
        ./agent-sandbox.nix
      ];
      app = {
        package = pkgs.claude-code;
        runScript = "env PATH=${oc}/bin:${opencode-unwrapped}/bin:$PATH CLAUDE_CONFIG_DIR=$HOME/.claude EDITOR=nvim VISUAL=nvim DISABLE_AUTOUPDATER=1 claude";
        bwrapPath = name;
        id = "dev.pengeg.claude.${name}";
      };
      mounts.sandbox = [
        {
          name = "claude";
          path = "$HOME/.claude";
        }
      ];
      mounts.readWrite = [
        {
          from = opencodeData;
          to = "$HOME/.local/share/opencode";
        }
        {
          from = "$HOME/.config/opencode";
          to = "$HOME/.config/opencode";
        }
        "$HOME/dev"
        "$HOME/documents"
        "$HOME/nixos"
      ];
      mounts.read = [
        opencodeGoKey
      ];
    };

  mkNamed =
    name:
    pkgs.writeShellScriptBin name ''
      exec ${mkClaudeSandboxed name}/bin/claude-code "$@"
    '';

  opencode-sandboxed = pkgs.mkBwrapper {
    imports = [
      pkgs.bwrapperPresets.devshell
      ./agent-sandbox.nix
    ];
    app = {
      package = pkgs.opencode;
      runScript = "opencode";
      bwrapPath = "opencode";
      id = "dev.pengeg.opencode";
    };
    mounts.sandbox = [
      {
        name = "data";
        path = "$HOME/.local/share/opencode";
      }
    ];
    mounts.readWrite = [
      {
        from = "$HOME/.config/opencode";
        to = "$HOME/.config/opencode";
      }
      "$HOME/dev"
      "$HOME/documents"
      "$HOME/nixos"
    ];
    mounts.read = [
      opencodeGoKey
    ];
  };
in
{
  home.packages = [
    (mkNamed "claude")
    (mkNamed "claude-work")
    opencode-sandboxed
    oc
  ];

  # single long-lived server owns the shared data dir; claude talks to it
  # via `oc` (HTTP) instead of cold-booting an instance per `opencode run`
  systemd.user.services.opencode-server = {
    Unit = {
      Description = "opencode headless server";
      After = [ "network.target" ];
      X-Config-Hash = builtins.hashFile "sha256" "${config.xdg.configFile."opencode/opencode.json".source
      }";
    };
    Service = {
      ExecStart = "${opencode-sandboxed}/bin/opencode serve --port ${toString serverPort} --hostname 127.0.0.1";
      WorkingDirectory = "/tmp";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };

  programs.opencode = {
    enable = true;
    package = null;
    settings = {
      autoupdate = false;
      provider.opencode-go.options.apiKey = "{file:${opencodeGoKey}}";

      agent.reviewer = {
        mode = "subagent";
        description = "Read-only review/analysis agent";
        tools = {
          write = false;
          edit = false;
        };
      };
    };
  };
}
