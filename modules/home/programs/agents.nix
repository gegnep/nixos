{
  config,
  pkgs,
  osConfig,
  ...
}:

let
  opencodeGoKey = osConfig.sops.secrets.opencode-go-key.path;

  # Authored harness config lives in ~/dev/harness; links are out-of-store so
  # edits land in the repo without a rebuild.
  harness = "${config.home.homeDirectory}/dev/harness";
  link = path: config.lib.file.mkOutOfStoreSymlink "${harness}/${path}";

  mkClaude =
    name: dir:
    pkgs.writeShellScriptBin name ''
      export CLAUDE_CONFIG_DIR="$HOME/${dir}"
      export DISABLE_AUTOUPDATER=1
      export EDITOR=nvim VISUAL=nvim
      exec ${pkgs.claude-code}/bin/claude "$@"
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
}
