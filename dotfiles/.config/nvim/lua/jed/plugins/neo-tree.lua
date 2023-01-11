return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v2.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  -- cmd = "Neotree",
  -- keys = [[\]],
  init = function()
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
  end,
  config = function()
    require("neo-tree").setup {
      source_selector = {
        winbar = true,
      },
      window = {
        mappings = {
          ["<space>"] = false,
        },
      },
      filesystem = {
        follow_current_file = true,
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          hide_dotfiles = false,
          hide_by_name = {
            ".git",
            ".svn",
          },
        },
      },
    }

    vim.keymap.set("n", [[\]], "<cmd>Neotree<cr>")
  end,
}
