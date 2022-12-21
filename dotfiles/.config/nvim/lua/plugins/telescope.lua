local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

local set = vim.keymap.set

set("n", "z=", "<cmd>Telescope spell_suggest<cr>")
set("n", "<leader>f?", "<cmd>Telescope builtin<cr>")
set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>")
set("n", "<leader>fr", "<cmd>Telescope resume<cr>")
set("n", "<leader>fw", "<cmd>Telescope grep_string<cr>")
set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
set("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>")
set("n", "<leader>ft", "<cmd>Telescope filetypes<cr>")
set("n", "<leader>fc", "<cmd>Telescope commands<cr>")
set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>")
set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
set("n", "<leader>fm", "<cmd>Telescope man_pages<cr>")

set("n", "<leader>fH", function()
  builtin.help_tags { default_text = vim.fn.expand("<cword>") }
end)
set("n", "<leader>fM", function()
  builtin.man_pages { default_text = vim.fn.expand("<cword>") }
end)

-- Extensions
set("n", "<leader>fp", "<cmd>Telescope project display_type=full<cr>")
set("n", "<leader>fe", "<cmd>Telescope file_browser<cr>")

local defaultVert = {
  i = {
    ["<cr>"] = actions.select_vertical,
  },
}

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ["<C-s>"] = actions.select_vertical,
        ["<esc>"] = actions.close,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
        ["<c-t>"] = require("trouble.providers.telescope").open_with_trouble,
      },
    },
    path_display = { "truncate" },
    layout_config = {
      prompt_position = "top",
      horizontal = {
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    layout_strategy = "horizontal",
    sorting_strategy = "ascending",
    prompt_prefix = " ",
    selection_caret = " ",
    winblend = 0,
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--follow",
      "--hidden",
    },
    file_ignore_patterns = {
      "^.git/",
      "^.svn/",
      "^.vscode%-server/",
      "^.cache/",
      "^.ghcup/",
      "src/parser.c",
      "site%-packages/",
    },
  },
  pickers = {
    find_files = {
      find_command = {
        "fd",
        "--type=f",
        "--hidden",
        "--follow",
        "--strip-cwd-prefix",
      },
    },
    colorscheme = {
      enable_preview = true,
    },
    man_pages = {
      sections = { "1", "2", "3" },
      mappings = defaultVert,
    },
    help_tags = { mappings = defaultVert },
    buffers = {
      mappings = {
        i = {
          ["<c-d>"] = actions.delete_buffer,
        },
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
    project = {
      base_dirs = {
        "~/dev",
      },
    },
  },
}

telescope.load_extension("ui-select")
telescope.load_extension("fzf")
telescope.load_extension("file_browser")
telescope.load_extension("project")
