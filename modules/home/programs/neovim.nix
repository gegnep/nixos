{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovide
  ];

  # im ngl claude helped write this, shoutout
  programs.nvf = {
    enable = true;
    settings.vim = {
      # ── Aliases ──
      viAlias = true;
      vimAlias = true;

      # ── General ──
      globals.mapleader = " ";
      lineNumberMode = "relNumber";
      searchCase = "smart";
      preventJunkFiles = true;

      # ── Raw vim options (vim.o.*) ──
      options = {
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
        expandtab = true;
        smartindent = true;
        wrap = false;
        termguicolors = true;
        signcolumn = "yes";
        updatetime = 250;
        splitright = true;
        splitbelow = true;
        scrolloff = 8;
        undofile = true;
        cursorline = true;
        mouse = "a";
        spelllang = "en_US";
        spell = false;
        list = true;
        listchars = "tab:→ ,trail:·,nbsp:␣";
        confirm = true;
        pumheight = 10;
      };

      # ── Clipboard ──
      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      # ── Theme (catppuccin mocha) ──
      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
      };

      # ── Treesitter ──
      treesitter.enable = true;

      # ── LSP ──
      lsp.enable = true;

      # ── Languages ──
      languages = {
        nix = {
          enable = true;
          format = {
            enable = true;
            type = [ "nixfmt" ];
          };
        };
        lua.enable = true;
        typescript = {
          enable = true;
          format = {
            enable = true;
            type = [ "prettierd" ];
          };
        };
        html.enable = true;
        css.enable = true;
        python.enable = true;
        rust.enable = true;
        clang.enable = true;
      };

      # ── Formatter (format-on-save via conform-nvim) ──
      formatter.conform-nvim = {
        enable = true;
        setupOpts.format_on_save = {
          lsp_fallback = true;
          timeout_ms = 500;
        };
      };

      # ── Autocomplete (nvim-cmp + luasnip + friendly-snippets) ──
      autocomplete.nvim-cmp = {
        enable = true;
        mappings = {
          complete = "<C-Space>";
          close = "<C-e>";
          confirm = "<CR>";
          next = "<Tab>";
          previous = "<S-Tab>";
          scrollDocsUp = "<C-b>";
          scrollDocsDown = "<C-f>";
        };
      };

      # ── Autopairs ──
      autopairs.nvim-autopairs.enable = true;

      # ── Statusline ──
      statusline.lualine = {
        enable = true;
        theme = "auto";
      };

      # ── File tree (nvim-tree) ──
      filetree.nvimTree = {
        enable = true;
        mappings.toggle = "<leader>e";
        setupOpts = {
          view.width = 30;
          filters.dotfiles = false;
          git = {
            enable = true;
            ignore = false;
          };
        };
      };

      # ── Git ──
      git = {
        enable = true;
        gitsigns.enable = true;
      };

      # ── Telescope ──
      telescope.enable = true;

      # ── Which-key ──
      binds.whichKey.enable = true;

      # ── Comments (gcc / gc) ──
      comments.comment-nvim.enable = true;

      # ── Indent guides ──
      visuals.indent-blankline.enable = true;

      # ── Extra packages (formatters used by conform) ──
      extraPackages = with pkgs; [
        prettierd
        stylua
        nixfmt
      ];

      # ── Keymaps ──
      keymaps = [
        # Telescope
        {
          key = "<leader>ff";
          mode = "n";
          action = "<cmd>Telescope find_files<CR>";
          silent = true;
          desc = "Find files";
        }
        {
          key = "<leader>fg";
          mode = "n";
          action = "<cmd>Telescope live_grep<CR>";
          silent = true;
          desc = "Grep";
        }
        {
          key = "<leader>fb";
          mode = "n";
          action = "<cmd>Telescope buffers<CR>";
          silent = true;
          desc = "Buffers";
        }

        # LSP
        {
          key = "gd";
          mode = "n";
          silent = true;
          desc = "Go to definition";
          lua = true;
          action = "vim.lsp.buf.definition";
        }
        {
          key = "gr";
          mode = "n";
          silent = true;
          desc = "References";
          lua = true;
          action = "vim.lsp.buf.references";
        }
        {
          key = "K";
          mode = "n";
          silent = true;
          desc = "Hover docs";
          lua = true;
          action = "vim.lsp.buf.hover";
        }
        {
          key = "<leader>ca";
          mode = "n";
          silent = true;
          desc = "Code action";
          lua = true;
          action = "vim.lsp.buf.code_action";
        }
        {
          key = "<leader>rn";
          mode = "n";
          silent = true;
          desc = "Rename";
          lua = true;
          action = "vim.lsp.buf.rename";
        }
        {
          key = "[d";
          mode = "n";
          silent = true;
          desc = "Prev diagnostic";
          lua = true;
          action = "vim.diagnostic.goto_prev";
        }
        {
          key = "]d";
          mode = "n";
          silent = true;
          desc = "Next diagnostic";
          lua = true;
          action = "vim.diagnostic.goto_next";
        }

        # Window navigation
        {
          key = "<C-h>";
          mode = "n";
          action = "<C-w>h";
        }
        {
          key = "<C-j>";
          mode = "n";
          action = "<C-w>j";
        }
        {
          key = "<C-k>";
          mode = "n";
          action = "<C-w>k";
        }
        {
          key = "<C-l>";
          mode = "n";
          action = "<C-w>l";
        }

        # Window resize
        {
          key = "<C-Up>";
          mode = "n";
          action = "<cmd>resize +2<CR>";
          silent = true;
        }
        {
          key = "<C-Down>";
          mode = "n";
          action = "<cmd>resize -2<CR>";
          silent = true;
        }
        {
          key = "<C-Left>";
          mode = "n";
          action = "<cmd>vertical resize -2<CR>";
          silent = true;
        }
        {
          key = "<C-Right>";
          mode = "n";
          action = "<cmd>vertical resize +2<CR>";
          silent = true;
        }
      ];

      # ── Custom Lua (Neovide + terminal transparency) ──
      # Runs after all plugin configs are loaded
      luaConfigPost = ''
        if vim.g.neovide then
          vim.g.neovide_opacity = 0.9
          vim.o.guifont = "Hack Nerd Font:h11"
        else
          vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
          vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
          vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
          vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
          vim.cmd [[
            highlight NvimTreeNormal guibg=NONE ctermbg=NONE
            highlight NvimTreeNormalNC guibg=NONE ctermbg=NONE
          ]]
        end
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "nix",
          callback = function()
            vim.bo.commentstring = "# %s"
          end,
        })
      '';
    };
  };
}
