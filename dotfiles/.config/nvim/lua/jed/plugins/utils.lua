return {
  "nvim-lua/plenary.nvim",
  {
    "dstein64/vim-startuptime",
    lazy = false,
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
      {
        "<leader>fs",
        function()
          require("auto-session.session-lens").search_session {
            theme_conf = {},
            previewer = false,
            path_display = { "truncate" },
          }
        end,
        desc = "Sessions",
      },
    },
    opts = {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/dev" },
      auto_session_use_git_branch = true,
      pre_save_cmds = { "tabdo Neotree close" },
      pre_restore_cmds = {
        function()
          vim.cmd("Neotree close")
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
        -- "Neotree",
        -- function()
        --   for _, win in ipairs(vim.api.nvim_list_wins()) do
        --     local buf = vim.api.nvim_win_get_buf(win)
        --     local ft = vim.api.nvim_buf_get_option(buf, "filetype")
        --     if ft == "neo-tree" then
        --       vim.api.nvim_win_set_width(win, 40)
        --       break
        --     end
        --   end
        -- end,
        -- "wincmd =",
      },
    },
  },
  {
    "RaafatTurki/hex.nvim",
    cmd = { "HexToggle", "HexDump", "HexAssemble" },
    opts = {},
  },
  {
    "NvChad/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    keys = {
      { "<leader>uc", "<cmd>ColorizerToggle<cr>", desc = "Toggle Colorizer" },
    },
    opts = {
      filetypes = {
        "css",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "html",
        "json",
        "yaml",
        "toml",
      },
      user_default_options = {
        tailwind = true,
        names = false,
      },
    },
  },
}
