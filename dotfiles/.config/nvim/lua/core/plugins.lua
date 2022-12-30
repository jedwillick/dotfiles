local function config(name)
  return function()
    require("plugins." .. name)
  end
end

return {
  {
    "jedwillick/version.nvim",
    config = true,
    event = "BufReadPre",
  },
  {
    "nvim-lua/plenary.nvim",
  },
  {
    "folke/tokyonight.nvim",
    config = config("tokyonight"),
    lazy = false,
    priority = 999,
  },
  {
    "goolord/alpha-nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = config("alpha"),
    event = "VimEnter",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      "nvim-treesitter/playground",
    },
    build = ":TSUpdate",
    -- event = "BufReadPost",
    lazy = false, -- TODO LAZY
    config = config("treesitter"),
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup { check_ts = true }
    end,
    event = "InsertEnter",
  },
  {
    "folke/neodev.nvim",
    config = true,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {
        window = { relative = "editor" },
        text = { spinner = "dots" },
      }
      -- HACK to stop error when exiting
      vim.api.nvim_create_autocmd("VimLeavePre", { command = [[silent! FidgetClose]] })
    end,
  },
  {
    "williamboman/mason.nvim",
    event = "VimEnter",
    dependencies = {
      { "neovim/nvim-lspconfig", commit = "709d322b456b5bbc4ed779f12048099200b5aa6b" },
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
      "p00f/clangd_extensions.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      {
        "SmiteshP/nvim-navic",
        config = function()
          require("nvim-navic").setup {
            depth_limit = 5,
            separator = "  ",
          }
        end,
      },
      "neodev.nvim",
      "fidget.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = config("lsp"),
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "chrisgrieser/cmp-nerdfont",
      "saadparwaiz1/cmp_luasnip",
    },
    config = config("cmp"),
  },

  -- use {
  --   "zbirenbaum/copilot.lua",
  --   requires = { "zbirenbaum/copilot-cmp" },
  --   event = "VimEnter",
  --   config = function()
  --     vim.defer_fn(function()
  --       require("copilot").setup {
  --         filetypes = {
  --           TelescopePrompt = false,
  --           man = false,
  --         },
  --       }
  --       require("copilot_cmp").setup()
  --     end, 100)
  --   end,
  -- }

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
      local ft = require("Comment.ft")
      ft.plsql = "-- %s"
      ft.c = "// %s"
      ft.editorconfig = "; %s"
    end,
    event = "BufReadPre",
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = config("bufferline"),
    event = "BufReadPre",
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    config = config("lualine"),
    event = "VimEnter",
  },

  {
    "NvChad/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    keys = {
      { "<leader>ct", "<cmd>ColorizerToggle<cr>" },
    },
    config = {
      filetypes = { "css", "javascript", "html", "json", "yaml", "toml" },
      user_default_options = {
        names = false,
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        char = "▏",
        show_trailing_blankline_indent = false,
        show_current_context = true,
      }
    end,
    event = "BufReadPre",
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter", -- TODO make maps in init
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "telescope-fzf-native.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = config("telescope"),
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    init = function()
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
    end,
    config = config("neo-tree"),
    lazy = false,
    -- cmd = "Neotree",
    -- keys = [[\]],
  },
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  {
    "AndrewRadev/sideways.vim",
    cmd = { "SidewaysLeft", "SidewaysRight" },
    init = function()
      vim.keymap.set("n", "<leader>h", ":SidewaysLeft<CR>")
      vim.keymap.set("n", "<leader>l", ":SidewaysRight<CR>")
    end,
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    init = function()
      vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")
    end,
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown" },
  },
  {
    "gpanders/editorconfig.nvim",
    config = config("editorconfig"),
    event = "VimEnter",
  },
  {
    "folke/which-key.nvim",
    config = {
      disable = {
        filetypes = { "TelescopePrompt", "neo-tree" },
      },
    },
    event = "User VeryLazy",
  },
  {
    "famiu/bufdelete.nvim",
    event = "BufReadPre",
  },
  {
    "akinsho/toggleterm.nvim",
    config = config("toggleterm"),
    event = "User VeryLazy",
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = true,
    event = "BufReadPre",
  },
  {
    "aserowy/tmux.nvim",
    init = function()
      vim.keymap.set({ "n", "t" }, "<A-up>", require("tmux").move_top)
      vim.keymap.set({ "n", "t" }, "<A-down>", require("tmux").move_bottom)
      vim.keymap.set({ "n", "t" }, "<A-left>", require("tmux").move_left)
      vim.keymap.set({ "n", "t" }, "<A-right>", require("tmux").move_right)
      vim.keymap.set({ "n", "t" }, "<A-S-up>", require("tmux").resize_top)
      vim.keymap.set({ "n", "t" }, "<A-S-down>", require("tmux").resize_bottom)
      vim.keymap.set({ "n", "t" }, "<A-S-left>", require("tmux").resize_left)
      vim.keymap.set({ "n", "t" }, "<A-S-right>", require("tmux").resize_right)
    end,
    config = function()
      require("tmux").setup {
        navigation = {
          enable_default_keybindings = false,
          persist_zoom = true,
        },
        resize = {
          enable_default_keybindings = false,
        },
      }
    end,
  },
  {
    "wakatime/vim-wakatime",
    build = function()
      local cli = (os.getenv("WAKATIME_HOME") or os.getenv("HOME")) .. "/.wakatime/wakatime-cli"
      local dest = (os.getenv("XDG_DATA_HOME") or os.getenv("HOME") .. "/.local") .. "/bin/wakatime-cli"
      vim.cmd(string.format("silent !ln -sf %s %s", cli, dest))
    end,
    event = "BufReadPost",
  },
  {
    "folke/trouble.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    cmd = { "TroubleToggle", "Trouble" },
    config = true,
  },
  {
    "ggandor/leap.nvim",
    event = "User VeryLazy",
    dependencies = { "ggandor/flit.nvim", "ggandor/leap-ast.nvim" },
    config = function()
      require("leap").add_default_mappings()
      require("flit").setup {
        labeled_modes = "nv",
      }
      vim.keymap.set({ "n", "x", "o" }, "M", function()
        require("leap-ast").leap()
      end, {})
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "User VeryLazy",
    config = true,
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = { "rmagatti/session-lens" },
    config = function()
      local as = require("auto-session")
      as.setup {
        log_level = "error",
        auto_session_use_git_branch = true,
      }
      require("session-lens").setup { path_display = { "truncate" }, theme_conf = {}, previewer = false }
      vim.keymap.set("n", "<leader>fs", "<cmd>SearchSession<cr>")
      --   vim.api.nvim_create_,r_command("SessionSave", function(_)
      --     local path = as.get_root_dir()
      --     if _.args ~= "" then
      --       path = string.format("%s/%s.vim", as.get_root_dir(), _.args)
      --     end
      --     as.SaveSession(path)
      --   end, { nargs = "?" })
    end,
  },
  {
    "gbprod/yanky.nvim",
    event = "User VeryLazy",
    dependencies = { "kkharji/sqlite.lua" },
    config = function()
      require("yanky").setup {
        highlight = {
          timer = 150,
        },
        ring = {
          storage = "sqlite",
        },
      }
      require("telescope").load_extension("yank_history")
      vim.keymap.set("n", "<leader>P", "<cmd>Telescope yank_history<cr>")
      vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set("n", "<tab>", "<Plug>(YankyCycleForward)")
      vim.keymap.set("n", "<S-tab>", "<Plug>(YankyCycleBackward)")
    end,
  },
  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
      require("notify").setup {
        timeout = 3000,
        level = vim.log.levels.INFO,
        fps = 20,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
      }
      vim.notify = require("notify")
    end,
  },
}
