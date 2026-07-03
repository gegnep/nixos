{
  pkgs,
  lib,
  ...
}:

let
  # mirrors mkClaudeSandboxed in claude.nix — same bwrapPath + mount name
  # means each variant shares ~/.bwrapper/<name>/claude/ with its CLI profile
  mkClaudeAcp =
    name:
    pkgs.mkBwrapper {
      imports = [ pkgs.bwrapperPresets.devshell ];
      app = {
        package = pkgs.claude-agent-acp;
        runScript = "env CLAUDE_CONFIG_DIR=$HOME/.claude claude-agent-acp";
        bwrapPath = name;
      };
      mounts.sandbox = [
        {
          name = "claude";
          path = "$HOME/.claude";
        }
      ];
    };

  codexAcp = pkgs.mkBwrapper {
    imports = [ pkgs.bwrapperPresets.devshell ];
    app = {
      package = pkgs.codex-acp;
      runScript = "env CODEX_HOME=$HOME/.codex codex-acp";
      bwrapPath = "codex";
    };
    mounts.sandbox = [
      {
        name = "codex";
        path = "$HOME/.codex";
      }
    ];
  };

  claudeAcp = mkClaudeAcp "claude";
  claudeAcpWork = mkClaudeAcp "claude-work";
in
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;

    extraPackages = with pkgs; [
      nixd
      nixfmt
      rust-analyzer
      clang-tools
      basedpyright
      ruff
      vtsls
      nodejs
      lua-language-server
      vscode-langservers-extracted
      package-version-server
    ];

    extensions = [
      "nix"
      "lua"
      "toml"
      "html"
      "scss"
      "git-firefly"
    ];

    userSettings = {
      auto_update = false;
      vim_mode = true;
      load_direnv = "shell_hook";
      buffer_font_family = "Hack Nerd Font";
      terminal.font_family = "Hack Nerd Font";
      theme.mode = "dark";

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      agent_servers = {
        "Claude Code - Personal" = {
          type = "custom";
          command = "${claudeAcp}/bin/claude-agent-acp";
          args = [ ];
        };
        "Claude Code - Work" = {
          type = "custom";
          command = "${claudeAcpWork}/bin/claude-agent-acp";
          args = [ ];
        };
        "Codex" = {
          type = "custom";
          command = "${codexAcp}/bin/codex-acp";
          args = [ ];
        };
      };

      languages = {
        Python.language_servers = [
          "basedpyright"
          "ruff"
          "!pyright"
        ];
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
          formatter.external = {
            command = "nixfmt";
            arguments = [ ];
          };
          format_on_save = "on";
        };
      };

      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      features.edit_prediction_provider = "none";
    };
  };
}
