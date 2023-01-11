return {
  "nvim-lua/plenary.nvim",
  "kyazdani42/nvim-web-devicons",
  "MunifTanjim/nui.nvim",

  {
    "stevearc/dressing.nvim",
    event = "BufReadPost",
  },
  {
    "jedwillick/version.nvim",
    config = true,
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
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
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
    event = "BufReadPre",
    config = function()
      require("indent_blankline").setup {
        char = "▏",
        show_trailing_blankline_indent = false,
        show_current_context = true,
      }
    end,
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
    "folke/which-key.nvim",
    config = {
      disable = {
        filetypes = { "TelescopePrompt", "neo-tree" },
      },
    },
    event = "User VeryLazy",
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
    event = "BufReadPost",
    build = function()
      local cli = (os.getenv("WAKATIME_HOME") or os.getenv("HOME")) .. "/.wakatime/wakatime-cli"
      local dest = (os.getenv("XDG_DATA_HOME") or os.getenv("HOME") .. "/.local") .. "/bin/wakatime-cli"
      vim.cmd(string.format("silent !ln -sf %s %s", cli, dest))
    end,
  },
  {
    "folke/trouble.nvim",
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
    config = {
      log_level = "error",
      auto_session_use_git_branch = true,
      pre_restore_cmds = {
        function()
          if vim.o.filetype == "lazy" then
            vim.g.lazy_auto_session = true
            vim.cmd.close()
          end
        end,
      },
      post_restore_cmds = {
        function()
          if vim.g.lazy_auto_session then
            require("lazy").show()
          end
        end,
      },
    },
  },
  {
    "rmagatti/session-lens",
    keys = {
      { "<leader>fs", "<cmd>SearchSession<cr>", desc = "Sessions" },
    },
    config = {
      path_display = { "truncate" },
      theme_conf = {},
      previewer = false,
    },
  },
  {
    "gbprod/yanky.nvim",
    event = "BufReadPost",
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
      vim.keymap.set("n", "<leader>P", function()
        require("telescope").extensions.yank_history.yank_history()
      end, { desc = "Yank history" })
      vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set("n", "[p", "<Plug>(YankyCycleForward)")
      vim.keymap.set("n", "]p", "<Plug>(YankyCycleBackward)")
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
