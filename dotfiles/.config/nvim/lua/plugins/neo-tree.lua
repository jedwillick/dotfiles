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
