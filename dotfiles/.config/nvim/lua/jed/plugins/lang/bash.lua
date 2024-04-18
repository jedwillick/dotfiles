return true
    and {
      {
        "nvim-treesitter",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "bash",
          })
        end,
      },
      {
        "mason.nvim",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "bash-language-server",
            "shfmt",
          })
        end,
      },
      {
        "nvim-lspconfig",
        opts = {
          servers = {
            bashls = {
              settings = {
                bashIde = {
                  shellcheckArguments = { "--exclude=1090,1091" },
                },
              },
            },
          },
        },
      },
      {
        "conform.nvim",
        opts = {
          formatters_by_ft = {
            bash = { "shfmt" },
            sh = { "shfmt" },
          },
          formatters = {
            shfmt = {
              prepend_args = function(self, ctx)
                return vim.tbl_isempty(vim.b.editorconfig or {})
                    and { "--indent=2", "--case-indent", "--binary-next-line", "--space-redirects" }
                  or {}
              end,
            },
          },
        },
      },
    }
  or {}
