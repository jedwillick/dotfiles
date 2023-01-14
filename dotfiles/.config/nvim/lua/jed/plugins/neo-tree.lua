return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  keys = {
    { [[\]], "<cmd>Neotree<cr>" },
  },
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
  end,
  opts = {
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
      filtered_items = {
        hide_dotfiles = false,
        hide_by_name = {
          ".git",
          ".svn",
        },
      },
    },
  },
}
