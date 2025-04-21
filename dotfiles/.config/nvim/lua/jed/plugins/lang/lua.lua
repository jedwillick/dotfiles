return true
    and {
      {
        "nvim-treesitter",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "lua",
          })
        end,
      },
      {
        "mason.nvim",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "lua-language-server",
            "stylua",
          })
        end,
      },
      {
        "nvim-lspconfig",
        opts = {
          servers = {
            lua_ls = {
              on_attach = function(client, _)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
              end,
              settings = {
                Lua = {
                  diagnostics = {
                    unusedLocalExclude = { "_*" },
                    ignoredFiles = "Enable",
                  },
                  format = {
                    enable = false,
                  },
                  telemetry = {
                    enable = false,
                  },
                  workspace = {
                    checkThirdParty = false,
                  },
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
            lua = { "stylua" },
          },
        },
      },
    }
  or {}
