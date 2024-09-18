return {
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    dependencies = {
      -- "RRethy/nvim-treesitter-endwise",
      "nvim-treesitter/nvim-treesitter-textobjects",

      -- "hiphish/rainbow-delimiters.nvim",
    },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "diff",
        "dockerfile",
        "gitcommit",
        "gitignore",
        "jq",
        "query",
        "regex",
        "vim",
        "vimdoc",
        -- "css",
        -- "fish",
        -- "go",
        -- "gomod",
        -- "gosum",
        -- "html",
        -- "http",
        -- "java",
        -- "javascript",
        -- "latex",
        -- "sql",
        -- "tsx",
        -- "typescript",
      },
      sync_install = #vim.api.nvim_list_uis() == 0,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = false },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = "<C-s>",
          node_decremental = "<C-b>",
        },
      },
      -- extensions
      -- endwise = { enable = true },
      playground = { enable = true },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
      matchup = { enable = true, disable_virtual_text = true },
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
          -- You can choose the select mode (default is charwise 'v')
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
          include_surrounding_whitespace = true,
        },
        swap = {
          enable = true,
          swap_next = {
            ["gz"] = "@parameter.inner",
          },
          swap_previous = {
            ["gZ"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
