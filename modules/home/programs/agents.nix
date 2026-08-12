{
  pkgs,
  osConfig,
  config,
  ...
}:

let
  opencodeGoKey = osConfig.sops.secrets.opencode-go-key.path;

  mkClaude =
    name:
    pkgs.writeShellScriptBin name ''
      export CLAUDE_CONFIG_DIR="$HOME/.bwrapper/${name}/claude"
      export DISABLE_AUTOUPDATER=1
      export EDITOR=nvim VISUAL=nvim
      exec ${pkgs.claude-code}/bin/claude "$@"
    '';

  codex-sandboxed = pkgs.mkBwrapper {
    imports = [
      pkgs.bwrapperPresets.devshell
      ./agent-sandbox.nix
    ];
    app = {
      package = pkgs.codex;
      runScript = "codex";
      bwrapPath = "codex";
      id = "dev.pengeg.codex";
    };
    mounts.sandbox = [
      {
        name = "codex";
        path = "$HOME/.codex";
      }
    ];
    mounts.readWrite = [
      "$HOME/dev"
      "$HOME/documents"
      "$HOME/nixos"
    ];
  };

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
    mounts.read = [ opencodeGoKey ];
  };
in
{
  home.packages = [
    (mkClaude "claude")
    (mkClaude "claude-work")
    codex-sandboxed
    opencode-sandboxed
  ];

  programs.opencode = {
    enable = true;
    package = null;
    settings = {
      autoupdate = false;
      provider.opencode-go.options.apiKey = "{file:${opencodeGoKey}}";
    };
  };
}
