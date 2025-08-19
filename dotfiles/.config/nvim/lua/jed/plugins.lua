return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
  },
  {
    "AndrewRadev/sideways.vim",
    enabled = false,
    cmd = { "SidewaysLeft", "SidewaysRight" },
    keys = {
      { "<leader>h", "<cmd>SidewaysLeft<cr>", desc = "Move argument left" },
      { "<leader>l", "<cmd>SidewaysRight<cr>", desc = "Move argument right" },
    },
  },
  {
    "mbbill/undotree",
    enabled = false,
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree" },
    },
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      disable = {
        filetypes = { "TelescopePrompt", "neo-tree" },
      },
      replace = { ["<leader>"] = "SPC" },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add {
        { "g", group = "+goto" },
        { "]", group = "+next" },
        { "[", group = "+prev" },
        { "<leader>b", group = "+buffer" },
        { "<leader>c", group = "+code" },
        { "<leader>f", group = "+find" },
        { "<leader>t", group = "+term" },
        { "<leader>n", group = "+notify/noice" },
        { "<leader>r", group = "+replace" },
      }
    end,
  },
  --{
  --  "aserowy/tmux.nvim",
  --  enabled = false,
  --  -- cond = function()
  --  --   return vim.env.TMUX ~= nil
  --  -- end,
  --  -- lazy = false,
  --  init = function()
  --    vim.keymap.set({ "n", "t" }, "<C-up>", function()
  --      require("tmux").move_top()
  --    end)
  --    vim.keymap.set({ "n", "t" }, "<C-down>", function()
  --      require("tmux").move_bottom()
  --    end)
  --    vim.keymap.set({ "n", "t" }, "<C-left>", function()
  --      require("tmux").move_left()
  --    end)
  --    vim.keymap.set({ "n", "t" }, "<C-right>", function()
  --      require("tmux").move_right()
  --    end)
  --    vim.keymap.set({ "n", "t" }, "<A-up>", function()
  --      require("tmux").resize_top()
  --    end)
  --    vim.keymap.set({ "n", "t" }, "<A-down>", function()
  --      require("tmux").resize_bottom()
  --    end)
  --    vim.keymap.set({ "n", "t" }, "<A-left>", function()
  --      require("tmux").resize_left()
  --    end)
  --    vim.keymap.set({ "n", "t" }, "<A-right>", function()
  --      require("tmux").resize_right()
  --    end)
  --  end,
  --  opts = {
  --    navigation = {
  --      enable_default_keybindings = false,
  --      persist_zoom = true,
  --    },
  --    resize = {
  --      enable_default_keybindings = false,
  --    },
  --  },
  --},
  --{
  --  "wakatime/vim-wakatime",
  --  event = { "BufReadPost", "BufNewFile" },
  --  build = function()
  --    local cli = (os.getenv("WAKATIME_HOME") or os.getenv("HOME")) .. "/.wakatime/wakatime-cli"
  --    local dest = (os.getenv("XDG_DATA_HOME") or os.getenv("HOME") .. "/.local") .. "/bin/wakatime-cli"
  --    vim.cmd(string.format("silent !ln -sf %s %s", cli, dest))
  --  end,
  --},
  {
    "gbprod/yanky.nvim",
    event = { "BufReadPost", "BufNewFile" },
    -- dependencies = { "kkharji/sqlite.lua" },
    config = function()
      require("yanky").setup {
        highlight = {
          timer = 250,
        },
        ring = {
          storage = "shada", -- "sqlite",
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
    "michaelb/sniprun",
    build = "bash ./install.sh",
    cmd = "SnipRun",
  },
  {
    "EtiamNullam/deferred-clipboard.nvim",
    enabled = false,
    lazy = false,
    opts = {
      lazy = true,
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = {
        before = "",
        keyword = "wide_fg",
        after = "",
        pattern = [[.*<(KEYWORDS)\s*:?]],
      },
    },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
    },
  },
}
