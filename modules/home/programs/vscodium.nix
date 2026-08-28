{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    bubblewrap
    socat
  ];

  home.file."${config.xdg.configHome}/VSCodium/User/settings.json".enable = lib.mkForce false;
  home.activation.vscodiumMutableSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    declared=${config.home.file."${config.xdg.configHome}/VSCodium/User/settings.json".source}
    target="${config.xdg.configHome}/VSCodium/User/settings.json"
    if [ -f "$target" ] && ${pkgs.jq}/bin/jq -e . "$target" >/dev/null 2>&1; then
      merged=$(${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$target" "$declared")
      run install -Dm644 <(printf '%s\n' "$merged") "$target"
    else
      run install -Dm644 "$declared" "$target"
    fi
  '';

  programs.vscodium = {
    enable = true;
    mutableExtensionsDir = false;
    argvSettings."password-store" = "gnome-libsecret";
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = [
        pkgs.vscode-extensions.vscodevim.vim

        pkgs.vscode-extensions.anthropic.claude-code
        pkgs.nix-vscode-extensions.open-vsx.sst-dev.opencode

        pkgs.vscode-extensions.jnoortheen.nix-ide
        pkgs.vscode-extensions.rust-lang.rust-analyzer
        pkgs.vscode-extensions.tamasfe.even-better-toml
        pkgs.vscode-extensions.mkhl.direnv
        pkgs.vscode-extensions.usernamehw.errorlens
        pkgs.vscode-extensions.editorconfig.editorconfig
        pkgs.vscode-extensions.charliermarsh.ruff
        pkgs.nix-vscode-extensions.open-vsx.detachhead.basedpyright
      ];

      userSettings = {
        "workbench.startupEditor" = "none";
        "editor.fontFamily" = "'Hack Nerd Font'";
        "terminal.integrated.fontFamily" = "'Hack Nerd Font'";
        "files.autoSave" = "onFocusChange";
        "editor.formatOnSave" = true;
        "editor.minimap.enabled" = false;
        "workbench.editor.enablePreview" = false;

        "files.watcherExclude" = {
          "**/.direnv/**" = true;
          "**/result/**" = true;
        };
        "search.exclude" = {
          "**/.direnv" = true;
          "**/result" = true;
        };
        "extensions.ignoreRecommendations" = true;

        "vim.leader" = "<space>";
        "vim.useSystemClipboard" = true;
        "vim.hlsearch" = true;
        "vim.handleKeys" = {
          "<C-p>" = false;
          "<C-b>" = false;
        };

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        "nix.serverSettings".nixd = {
          formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
          options = {
            nixos.expr = ''(builtins.getFlake "/home/pengeg/nixos").nixosConfigurations.blackbox.options'';
            home-manager.expr = ''(builtins.getFlake "/home/pengeg/nixos").nixosConfigurations.blackbox.options.home-manager.users.type.getSubOptions [ ]'';
          };
        };
        "ruff.path" = [ "${pkgs.ruff}/bin/ruff" ];

        # Share auth/config/ide-lockfiles with the `claude` wrapper
        "claudeCode.environmentVariables" = [
          {
            name = "CLAUDE_CONFIG_DIR";
            value = "${config.home.homeDirectory}/.claude-personal";
          }
        ];
      };

      keybindings = [
        # unbind opencode defaults (collide with claude-code)
        {
          key = "ctrl+escape";
          command = "-opencode.openTerminal";
        }
        {
          key = "ctrl+shift+escape";
          command = "-opencode.openNewTerminal";
        }
        {
          key = "ctrl+alt+k";
          command = "-opencode.addFilepathToTerminal";
        }
        # rebind
        {
          key = "ctrl+alt+o";
          command = "opencode.openTerminal";
        }
        {
          key = "ctrl+alt+shift+o";
          command = "opencode.openNewTerminal";
        }
        {
          key = "ctrl+alt+l";
          command = "opencode.addFilepathToTerminal";
        }
      ];
    };
  };
}
