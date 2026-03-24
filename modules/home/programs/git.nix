{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "pengeg";
        email = "noreply@pengeg.com";
      };
      pull.rebase = true;
      init.defaultBranch = "main";
      diff.algorithm = "histogram";
    };
    ignores = [
      "result"
      "result-*"
      ".direnv/"
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
  catppuccin.lazygit.enable = true;
}
