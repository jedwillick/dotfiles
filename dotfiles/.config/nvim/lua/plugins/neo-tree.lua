vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require("neo-tree").setup {
  source_selector = {
    winbar = true,
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
}

vim.keymap.set("n", [[\]], "<cmd>Neotree<cr>")
