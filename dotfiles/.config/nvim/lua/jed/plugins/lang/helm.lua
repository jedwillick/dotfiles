return true
    and {
      { "towolf/vim-helm", ft = "helm" },
      {
        "nvim-treesitter",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "helm",
          })
        end,
      },
      {
        "mason.nvim",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "helm-ls",
          })
        end,
      },
      {
        "nvim-lspconfig",
        opts = {
          servers = {
            helm_ls = {},
          },
        },
      },
      {
        "conform.nvim",
        opts = {
          formatters_by_ft = {
          },
        },
      },
    }
  or {}
