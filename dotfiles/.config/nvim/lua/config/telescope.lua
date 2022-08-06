local opts = { noremap = true }
nmap("<leader>ff", [[<cmd>Telescope find_files hidden=true no_ignore=true<cr>]], opts)
nmap("<leader>fg", [[<cmd>Telescope live_grep<cr>]], opts)
nmap("<leader>fb", [[<cmd>Telescope buffers<cr>]], opts)
nmap("<leader>fh", [[<cmd>Telescope help_tags<cr>]], opts)
nmap("<leader>fm", [[<cmd>Telescope man_pages<cr>]], opts)
nmap("z=", [[<cmd>Telescope spell_suggest<cr>]], opts)

local actions = require("telescope.actions")

require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<C-s>"] = actions.select_vertical,
        ["<esc>"] = actions.close,
      },
      n = {
        ["<C-s>"] = actions.select_vertical,
      }
    }
  },

  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
  },

  pickers = {
    find_files = {
      find_command = {
        "fd", "--type", "f", "--hidden", "--no-ignore", "--follow", "--exclude", ".git", "--exclude", ".svn",
        "--strip-cwd-prefix"
      },
      -- hidden = true,
      -- follow = true,
      -- no_ignore = true
    },
    man_pages = {
      cmd = "vertical",
    }
  }
}

require("telescope").load_extension("ui-select")
