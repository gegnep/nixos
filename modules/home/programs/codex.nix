{
  pkgs,
  ...
}:

let
  codex-sandboxed = pkgs.mkBwrapper {
    imports = [ pkgs.bwrapperPresets.devshell ];
    app = {
      package = pkgs.codex;
      runScript = "env CODEX_HOME=$HOME/.codex codex";
      bwrapPath = "codex";
      id = "dev.pengeg.codex";
    };
    mounts.sandbox = [
      {
        name = "codex";
        path = "$HOME/.codex";
      }
    ];
  };
in
{
  home.packages = [ codex-sandboxed ];
}
