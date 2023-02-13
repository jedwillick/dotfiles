return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "jvgrootveld/telescope-zoxide",
    },
    cmd = "Telescope",
    keys = {
      { "z=", "<cmd>Telescope spell_suggest<cr>" },
      { "<leader>f?", "<cmd>Telescope builtin<cr>", desc = "Telescope" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Resume previous" },
      { "<leader>fG", "<cmd>Telescope grep_string<cr>", desc = "Grep (word)" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in Buffer" },
      { "<leader>ft", "<cmd>Telescope filetypes<cr>", desc = "Filetypes" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      {
        "<leader>fH",
        function()
          require("telescope.builtin").help_tags { default_text = vim.fn.expand("<cword>") }
        end,
        desc = "Help Pages (word)",
      },
      {
        "<leader>fM",
        function()
          require("telescope.builtin").man_pages { default_text = vim.fn.expand("<cword>") }
        end,
        desc = "Man Pages (word)",
      },

      -- Extensions
      { "<leader>fp", "<cmd>Telescope project display_type=full<cr>", desc = "Projects" },
      { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
      { "<leader>z", "<cmd>Telescope zoxide list<cr>", desc = "Zoxide" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local defaultVert = {
        i = {
          ["<cr>"] = actions.select_vertical,
        },
      }

      local open_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end

      local no_ignore = false
      local toggle_ignored = function()
        no_ignore = not no_ignore
        return require("telescope.builtin").find_files { no_ignore = no_ignore }
      end

      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<c-t>"] = open_trouble,
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
            mappings = {
              i = {
                ["<A-i>"] = toggle_ignored,
              },
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
          project = {
            base_dirs = {
              "~/dev",
            },
          },
        },
      }

      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("project")
      telescope.load_extension("zoxide")
    end,
  },
}
