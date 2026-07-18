{ pkgs, osConfig, ... }:

let
  opencodeData = "$HOME/.bwrapper/opencode/data";
  openrouterKey = osConfig.sops.secrets.openrouter-key.path;

  opencode-sandboxed = pkgs.mkBwrapper {
    imports = [ pkgs.bwrapperPresets.devshell ];
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
    ];
    mounts.read = [
      openrouterKey
    ];
  };
in
{
  home.packages = [ opencode-sandboxed ];

  programs.opencode = {
    enable = true;
    package = null;
    settings = {
      autoupdate = false;
      provider.openrouter.options.apiKey = "{file:${openrouterKey}}";

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
