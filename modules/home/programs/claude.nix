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
        # state persists per-variant under ~/.bwrapper/<bwrapPath>/
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

  # every sandboxed build exposes the same bin/claude-code entry point,
  # which would collide in the profile; rename so both fit on PATH
  mkNamed =
    name:
    pkgs.writeShellScriptBin name ''
      exec ${mkClaudeSandboxed name}/bin/claude-code "$@"
    '';
in
{
  home.packages = [
    (mkNamed "claude")
    (mkNamed "claude-work")
  ];
}
