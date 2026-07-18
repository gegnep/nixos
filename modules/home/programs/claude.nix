{ pkgs, osConfig, ... }:
let
  opencode-unwrapped = pkgs.writeShellScriptBin "opencode" ''
    exec ${pkgs.opencode}/bin/opencode "$@"
  '';
  opencodeData = "$HOME/.bwrapper/opencode/data";
  openrouterKey = osConfig.sops.secrets.openrouter-key.path;

  mkClaudeSandboxed =
    name:
    pkgs.mkBwrapper {
      imports = [ pkgs.bwrapperPresets.devshell ];
      app = {
        package = pkgs.claude-code;
        runScript = "env PATH=${opencode-unwrapped}/bin:$PATH CLAUDE_CONFIG_DIR=$HOME/.claude EDITOR=nvim VISUAL=nvim DISABLE_AUTOUPDATER=1 claude";
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
      ];
      mounts.read = [
        openrouterKey
      ];
    };

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
