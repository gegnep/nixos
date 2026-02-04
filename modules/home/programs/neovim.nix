{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # LSP servers
      lua-language-server
      nil
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      pyright
      rust-analyzer
      clang-tools

      # Formatters
      nixfmt
      prettierd
      stylua
    ];

    plugins = with pkgs.vimPlugins; [
      # Theme
      {
        plugin = catppuccin-nvim;
        type = "lua";
        config = ''
          require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = true,
          })
          vim.cmd.colorscheme "catppuccin"

	  -- Force transparency
          vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
          vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
          vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
          vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
        '';
      }

      # Syntax highlighting
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function()
              pcall(vim.treesitter.start)
            end,
          })
        '';
      }

      # File browser
      nvim-web-devicons
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require("nvim-tree").setup({
            view = { width = 30 },
            filters = { dotfiles = false },
            git = { enable = true, ignore = false },
          })
        '';
      }

      # LSP
      {
        plugin = nvim-lspconfig;
  	type = "lua";
 	 config = ''
           -- Native LSP config (Neovim 0.11+)
           local capabilities = require("cmp_nvim_lsp").default_capabilities()

           vim.lsp.config("*", {
             capabilities = capabilities,
           })

           vim.lsp.config("lua_ls", {
             settings = {
               Lua = {
                 diagnostics = { globals = { "vim" } },
               },
	     },
           })

           vim.lsp.enable({
             "lua_ls",
             "nil_ls",
             "ts_ls",
             "html",
             "cssls",
             "jsonls",
             "pyright",
             "rust_analyzer",
             "clangd",
           })
  	'';
      }

      # Autocompletion
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      luasnip
      friendly-snippets
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require("cmp")
          local luasnip = require("luasnip")
          require("luasnip.loaders.from_vscode").lazy_load()

          cmp.setup({
            snippet = {
              expand = function(args) luasnip.lsp_expand(args.body) end,
            },
            mapping = cmp.mapping.preset.insert({
              ["<C-b>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.abort(),
              ["<CR>"] = cmp.mapping.confirm({ select = true }),
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                else fallback() end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                else fallback() end
              end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "luasnip" },
              { name = "buffer" },
              { name = "path" },
            }),
          })
        '';
      }

      # Autopairs
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require("nvim-autopairs").setup({})
          require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
        '';
      }

      # Status line
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require("lualine").setup({
            options = { theme = "catppuccin" },
          })
        '';
      }

      # Git signs
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''require("gitsigns").setup()'';
      }

      # Fuzzy finder
      plenary-nvim
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          require("telescope").setup({
            defaults = { file_ignore_patterns = { "node_modules", ".git/" } },
          })
        '';
      }

      # Which-key
      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''require("which-key").setup()'';
      }

      # Comments (gcc to toggle line, gc in visual mode)
      {
        plugin = comment-nvim;
        type = "lua";
        config = ''require("Comment").setup()'';
      }

      # Indent guides
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''require("ibl").setup()'';
      }
    ];

    initLua = ''
      -- Settings
      vim.g.mapleader = " "
      local opt = vim.opt
      opt.number = true
      opt.relativenumber = true
      opt.tabstop = 2
      opt.shiftwidth = 2
      opt.softtabstop = 2
      opt.expandtab = true
      opt.smartindent = true
      opt.wrap = false
      opt.ignorecase = true
      opt.smartcase = true
      opt.termguicolors = true
      opt.signcolumn = "yes"
      opt.updatetime = 250
      opt.splitright = true
      opt.splitbelow = true
      opt.clipboard = "unnamedplus"
      opt.scrolloff = 8
      opt.undofile = true
      opt.cursorline = true
      opt.mouse = "a"

      -- Keymaps (leader = space)
      local map = vim.keymap.set

      -- File browser
      map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

      -- Telescope
      map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
      map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Grep" })
      map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Buffers" })

      -- LSP
      map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      map("n", "gr", vim.lsp.buf.references, { desc = "References" })
      map("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
      map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
      map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
      map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
      map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

      -- Window navigation
      map("n", "<C-h>", "<C-w>h")
      map("n", "<C-j>", "<C-w>j")
      map("n", "<C-k>", "<C-w>k")
      map("n", "<C-l>", "<C-w>l")

      -- Force transparency (backup)
      vim.cmd [[
        highlight Normal guibg=NONE ctermbg=NONE
        highlight NormalNC guibg=NONE ctermbg=NONE
        highlight NormalFloat guibg=NONE ctermbg=NONE
        highlight SignColumn guibg=NONE ctermbg=NONE
        highlight NvimTreeNormal guibg=NONE ctermbg=NONE
        highlight NvimTreeNormalNC guibg=NONE ctermbg=NONE
      ]]
    '';
  };
}
