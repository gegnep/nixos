{ pkgs, ... }:
let
  # unwrapped codex, PATH-injected only inside the claude sandboxes: the
  # sandboxed wrapper can't nest (its document-portal bind fails in here),
  # and claude's own bwrap already confines it. Deliberately NOT in
  # home.packages — host PATH keeps resolving to the sandboxed codex.
  codex-unwrapped = pkgs.writeShellScriptBin "codex" ''
    exec ${pkgs.codex}/bin/codex "$@"
  '';
  # host-side state dir of the standalone codex sandbox (~/.codex inside
  # it) — mounted read-write so codex auth/config is shared, not per-variant
  codexState = "$HOME/.bwrapper/codex/codex";
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
        runScript = "env PATH=${codex-unwrapped}/bin:$PATH CODEX_HOME=${codexState} CLAUDE_CONFIG_DIR=$HOME/.claude EDITOR=nvim VISUAL=nvim DISABLE_AUTOUPDATER=1 claude";
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
      mounts.readWrite = [ codexState ];
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
