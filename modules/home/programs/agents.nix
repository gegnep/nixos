{
  config,
  pkgs,
  inputs,
  osConfig,
  ...
}:

let
  opencodeGoKey = osConfig.sops.secrets.opencode-go-key.path;

  # numtide/llm-agents.nix: daily-updated, prebuilt on cache.numtide.com.
  # Its README still advertises overlays.default; the flake only exports
  # overlays.shared-nixpkgs now, so index packages directly.
  llm = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  # Authored harness config lives in ~/dev/harness
  # links are out-of-store so edits land in the repo without a rebuild.
  harness = "${config.home.homeDirectory}/dev/harness";
  link = path: config.lib.file.mkOutOfStoreSymlink "${harness}/${path}";

  # Two Claude Code profiles: personal (Max plan) and work (Team seat).
  # CLAUDE_CONFIG_DIR selects the profile; the shared hooks read its basename.
  mkClaude =
    name: dir: extraArgs:
    pkgs.writeShellScriptBin name ''
      export CLAUDE_CONFIG_DIR="$HOME/${dir}"
      export DISABLE_AUTOUPDATER=1
      export EDITOR=nvim VISUAL=nvim
      exec ${llm.claude-code}/bin/claude ${extraArgs} "$@"
    '';

  # Repos every delegate may write to. A write outside these lands in the
  # sandbox tmpfs and vanishes.
  agentMounts = [
    "$HOME/dev"
    "$HOME/documents"
    "$HOME/nixos"
  ];

  # opencode: personal-profile delegate (GPT sub, Z.AI plan, Go sub, OpenRouter).
  opencode-sandboxed = pkgs.mkBwrapper {
    imports = [
      pkgs.bwrapperPresets.devshell
      ./agent-sandbox.nix
    ];
    app = {
      package = llm.opencode;
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
    ]
    ++ agentMounts;
    mounts.read = [
      opencodeGoKey
      {
        from = "$HOME/dev/harness/claude/skills";
        to = "$HOME/.claude/skills";
      }
    ];
  };

  # kiro-cli: work-profile delegate (gpt-5.6-luna at 0.1x credits, sol on request).
  kiro-cli = pkgs.kiro-cli-unwrapped.overrideAttrs { pname = "kiro-cli"; };
  kiro-sandboxed = pkgs.mkBwrapper {
    imports = [
      pkgs.bwrapperPresets.devshell
      ./agent-sandbox.nix
    ];
    app = {
      package = kiro-cli;
      runScript = "kiro-cli";
      bwrapPath = "kiro";
      id = "dev.pengeg.kiro";
    };
    mounts.sandbox = [
      {
        name = "kiro";
        path = "$HOME/.kiro";
      }
      {
        name = "kiro-cli";
        path = "$HOME/.local/share/kiro-cli";
      }
      {
        name = "mcp-auth";
        path = "$HOME/.mcp-auth";
      }
      {
        name = "npm-cache";
        path = "$HOME/.npm";
      }
    ];
    mounts.readWrite = agentMounts;
    mounts.read = [
      {
        from = "$HOME/dev/harness/claude-work/kiro-agents";
        to = "$HOME/.kiro/agents";
      }
    ];
  };
in
{
  home.packages = [
    (mkClaude "claude" ".claude-personal" "")
    # work: MCP servers come from the repo file, not claude.ai connectors
    (mkClaude "claude-work" ".claude-work" "--mcp-config $HOME/.claude-work/mcp.json")
    opencode-sandboxed
    kiro-sandboxed

    llm.tuicr
  ];

  home.file = {
    # personal profile
    ".claude-personal/CLAUDE.md".source = link "claude/CLAUDE.md";
    ".claude-personal/models.md".source = link "claude/models.md";
    ".claude-personal/settings.json".source = link "claude/settings.json";
    ".claude-personal/agents".source = link "claude/agents";
    ".claude-personal/skills".source = link "claude/skills";
    # work profile: own steering and agents, shared skills and hooks
    ".claude-work/CLAUDE.md".source = link "claude-work/CLAUDE.md";
    ".claude-work/work.md".source = link "claude-work/work.md";
    ".claude-work/models.md".source = link "claude-work/models.md";
    ".claude-work/settings.json".source = link "claude-work/settings.json";
    ".claude-work/agents".source = link "claude-work/agents";
    ".claude-work/mcp.json".source = link "claude-work/mcp.json";
    ".claude-work/skills".source = link "claude/skills";
    # opencode
    ".config/opencode/AGENTS.md".source = link "opencode/AGENTS.md";
    ".config/opencode/agents".source = link "opencode/agents";
    ".config/opencode/opencode.json".source = link "opencode/opencode.json";
    ".config/opencode/plugins".source = link "opencode/plugins";
  };

  xdg.configFile."tuicr/config.toml".text = ''
    theme = "catppuccin-mocha"
    diff_view = "side-by-side"
    mouse = true
    username = "pengeg"

    comment_types = [
      { id = "issue", color = "red", definition = "must fix before merge" },
      { id = "suggestion", color = "yellow", definition = "consider, or explain why not" },
      { id = "note", color = "blue", definition = "note or question; answer it" },
      { id = "praise", color = "green", definition = "no action" },
    ]
  '';
}
