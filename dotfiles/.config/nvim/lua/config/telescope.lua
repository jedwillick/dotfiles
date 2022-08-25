local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

local set = vim.keymap.set

set("n", "<leader>f?", builtin.builtin)
set("n", "<leader>ff", builtin.find_files)
set("n", "<leader>fo", builtin.oldfiles)
set("n", "<leader>fr", builtin.resume)
set("n", "<leader>fw", builtin.grep_string)
set("n", "<leader>fg", builtin.live_grep)
set("n", "<leader>fb", builtin.buffers)
set("n", "<leader>fs", builtin.current_buffer_fuzzy_find)
set("n", "<leader>ft", builtin.filetypes)
set("n", "z=", builtin.spell_suggest)

set("n", "<leader>fh", function()
  builtin.help_tags { default_text = vim.fn.expand("<cword>") }
end)
set("n", "<leader>fm", function()
  builtin.man_pages { default_text = vim.fn.expand("<cword>") }
end)

-- Extensions
set("n", "<leader>fp", ":Telescope project display_type=full<cr>")
set("n", "<leader>fe", ":Telescope file_browser<cr>")

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
      },
    },
    prompt_prefix = "  ",
    layout_config = {
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
  },
  pickers = {
    find_files = {
      find_command = {
        "fd",
        "--type=f",
        "--hidden",
        "--follow",
        "--exclude=.git",
        "--exclude=.svn",
        "--strip-cwd-prefix",
      },
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
        "~",
      },
      mappings = {
        i = {
          ["<cr>"] = function(bufnr)
            local projectActions = require("telescope._extensions.project.actions")
            projectActions.change_working_directory(bufnr)
            projectActions.browse_project_files(bufnr)
          end,
        },
      },
    },
  },
}

telescope.load_extension("ui-select")
telescope.load_extension("fzf")
telescope.load_extension("file_browser")
telescope.load_extension("project")
