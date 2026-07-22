{ pkgs, ... }:

let
  kiro-sandboxed = pkgs.mkBwrapper {
    imports = [
      pkgs.bwrapperPresets.devshell
      ./agent-sandbox.nix
    ];
    app = {
      package = pkgs.kiro-cli;
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
  };
in
{
  home.packages = [ kiro-sandboxed ];
}
