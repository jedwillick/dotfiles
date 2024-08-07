return true
    and {
      {
        "nvim-treesitter",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "javascript",
            "typescript",
          })
        end,
      },
      {
        "mason.nvim",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "typescript-language-server",
          })
        end,
      },
      {
        "pmizio/typescript-tools.nvim",
        ft = { "typescript", "javascript" },
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
          settings = {
            tsserver_format_options = {
              semicolons = "insert",
            },
          },
        },
      },

      -- {
      --   "nvim-lspconfig",
      --   opts = {
      --     servers = {
      --       tsserver = {
      --         settings = {
      --           typescript = { format = { semicolons = "insert" } },
      --           javascript = { format = { semicolons = "insert" } },
      --         },
      --       },
      --     },
      --   },
      -- },
    }
  or {}
