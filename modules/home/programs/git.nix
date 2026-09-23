{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "pengeg";
        email = "noreply@pengeg.com";
      };
      safe.directory = [
        "/home/pengeg/nixos"
      ];
      alias = {
        lg = "log --graph --all --decorate --oneline --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
        st = "status -sb";
        last = "log -1 HEAD --stat";
      };
      pull.rebase = true;
      # Upstream reflog entries from a partly rejected multi-URL push made
      # fork-point drop a local commit on pull --rebase (2026-09-23).
      rebase.forkPoint = false;
      init.defaultBranch = "main";
      diff.algorithm = "histogram";
    };
    ignores = [
      "result"
      "result-*"
      "*.swp"
      "*.swo"
      "*~"
      ".vscode/"
      ".idea/"
      ".DS_Store"
      "Thumbs.db"
      "node_modules/"
      "__pycache__/"
      "*.pyc"
      ".venv/"
      "venv/"
      "target/"
      "dist/"
      "build/"
      "*.o"
      "*.so"
      ".env"
      ".env.*"
      "!.env.example"
    ];
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui.showCommandLog = false;
    };
  };
}
