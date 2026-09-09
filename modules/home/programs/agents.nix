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

  mkClaude =
    name: dir:
    pkgs.writeShellScriptBin name ''
      export CLAUDE_CONFIG_DIR="$HOME/${dir}"
      export DISABLE_AUTOUPDATER=1
      export EDITOR=nvim VISUAL=nvim
      exec ${llm.claude-code}/bin/claude "$@"
    '';

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
      "$HOME/dev"
      "$HOME/documents"
      "$HOME/nixos"
    ];
    mounts.read = [
      opencodeGoKey
      {
        from = "$HOME/dev/harness/claude/skills";
        to = "$HOME/.claude/skills";
      }
    ];
  };
in
{
  home.packages = [
    (mkClaude "claude" ".claude-personal")
    (mkClaude "claude-work" ".claude-work")
    opencode-sandboxed

    llm.tuicr
  ];

  home.file = {
    ".claude-personal/CLAUDE.md".source = link "claude/CLAUDE.md";
    ".claude-personal/models.md".source = link "claude/models.md";
    ".claude-personal/settings.json".source = link "claude/settings.json";
    ".claude-personal/agents".source = link "claude/agents";
    ".claude-personal/skills".source = link "claude/skills";
    ".config/opencode/AGENTS.md".source = link "opencode/AGENTS.md";
    ".config/opencode/agents".source = link "opencode/agents";
    ".config/opencode/opencode.json".source = link "opencode/opencode.json";
  };

  xdg.configFile."tuicr/config.toml".text = ''
    theme = "catppuccin-mocha"
    diff_view = "side-by-side"
    mouse = true
    username = "pengeg"

    comment_types = [
      { id = "issue", color = "red", definition = "must fix before merge" },
      { id = "suggestion", color = "yellow", definition = "consider, or explain why not" },
      { id = "note", color = "blue", definition = "question or context; answer it" },
      { id = "praise", color = "green", definition = "no action" },
    ]
  '';
}
