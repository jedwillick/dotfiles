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
      filetypes = { "css", "javascript", "html", "json", "yaml", "toml" },
      user_default_options = {
        names = false,
      },
    },
  },
}
