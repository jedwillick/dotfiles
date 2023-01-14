return {
  "nvim-lua/plenary.nvim",
  "kyazdani42/nvim-web-devicons",
  "MunifTanjim/nui.nvim",

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  {
    "jedwillick/version.nvim",
    config = true,
  },
  {
    "windwp/nvim-autopairs",
    opts = { check_ts = true },
    event = "InsertEnter",
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
    opts = {
      filetypes = { "css", "javascript", "html", "json", "yaml", "toml" },
      user_default_options = {
        names = false,
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    opts = {
      char = "▏",
      show_trailing_blankline_indent = false,
      show_current_context = true,
    },
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
    keys = {
      { "<leader>h", "<cmd>SidewaysLeft<cr>", desc = "Move argument left" },
      { "<leader>l", "<cmd>SidewaysRight<cr>", desc = "Move argument right" },
    },
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree" },
    },
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      disable = {
        filetypes = { "TelescopePrompt", "neo-tree" },
      },
      key_labels = { ["<leader>"] = "SPC" },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register {
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+find" },
        ["<leader>t"] = { name = "+term" },
        ["<leader>n"] = { name = "+notify/noice" },
      }
    end,
  },
  {
    "aserowy/tmux.nvim",
    lazy = false,
    init = function()
      vim.keymap.set({ "n", "t" }, "<A-up>", function()
        require("tmux").move_top()
      end)
      vim.keymap.set({ "n", "t" }, "<A-down>", function()
        require("tmux").move_bottom()
      end)
      vim.keymap.set({ "n", "t" }, "<A-left>", function()
        require("tmux").move_left()
      end)
      vim.keymap.set({ "n", "t" }, "<A-right>", function()
        require("tmux").move_right()
      end)
      vim.keymap.set({ "n", "t" }, "<A-S-up>", function()
        require("tmux").resize_top()
      end)
      vim.keymap.set({ "n", "t" }, "<A-S-down>", function()
        require("tmux").resize_bottom()
      end)
      vim.keymap.set({ "n", "t" }, "<A-S-left>", function()
        require("tmux").resize_left()
      end)
      vim.keymap.set({ "n", "t" }, "<A-S-right>", function()
        require("tmux").resize_right()
      end)
    end,
    opts = {
      navigation = {
        enable_default_keybindings = false,
        persist_zoom = true,
      },
      resize = {
        enable_default_keybindings = false,
      },
    },
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
    dependencies = { "ggandor/flit.nvim" },
    config = function()
      require("leap").add_default_mappings()
      require("flit").setup {
        labeled_modes = "nv",
      }
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
      auto_session_suppress_dirs = { "~/", "~/dev" },
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
    -- lazy = false,
    event = "VeryLazy",
    keys = {
      {
        "<leader>nn",
        function()
          require("notify").dismiss { silent = true, pending = true }
        end,
        desc = "Dismiss all notifications",
      },
    },
    config = function()
      require("notify").setup {
        timeout = 3000,
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
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = function()
      local scrollbar = require("scrollbar")
      scrollbar.setup {
        excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "notify" },
      }
    end,
  },
  {
    "danymat/neogen",
    cmd = "Neogen",
    keys = {
      { "<leader>cd", "<cmd>Neogen<cr>", desc = "Generate docstring" },
    },
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      snippet_engine = "luasnip",
    },
  },
  {
    "michaelb/sniprun",
    build = "bash ./install.sh",
    cmd = "SnipRun",
  },
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },
}
