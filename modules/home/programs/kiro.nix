{ pkgs, ... }:

let
  kiro-sandboxed = pkgs.mkBwrapper {
    imports = [ pkgs.bwrapperPresets.devshell ];
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
    ];
  };
in
{
  home.packages = [ kiro-sandboxed ];
}
