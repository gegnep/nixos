{ pkgs, ... }:
let
  mkClaudeSandboxed =
    name:
    pkgs.mkBwrapper {
      imports = [ pkgs.bwrapperPresets.devshell ];
      app = {
        package = pkgs.claude-code;
        # CLAUDE_CONFIG_DIR relocates ~/.claude.json into the persisted
        # mount below. Do NOT add a mounts.sandbox entry for ~/.claude.json:
        # bwrapper binds a directory over file paths, which EISDIR-breaks
        # claude-code's startup read → full re-onboarding every launch.
        runScript = "env CLAUDE_CONFIG_DIR=$HOME/.claude claude";
        bwrapPath = name;
        id = "dev.pengeg.claude.${name}";
      };
      mounts.sandbox = [
        {
          name = "claude";
          path = "$HOME/.claude";
        }
      ];
    };

  claudeDefault = mkClaudeSandboxed "claude";
  claudeWork = mkClaudeSandboxed "claude-work";
in
{
  programs.zsh.shellAliases = {
    claude = "${claudeDefault}/bin/claude-code";
    claude-work = "${claudeWork}/bin/claude-code";
  };
}
