return true
    and {
      {
        "nvim-treesitter",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "json",
            "json5",
            "jsonc",
            "xml",
            "yaml",
            "toml",
          })
        end,
      },
      {
        "mason.nvim",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "json-lsp",
            "prettier",
            "yaml-language-server",
          })
        end,
      },
      {
        "b0o/SchemaStore.nvim",
        version = false, -- last release is way too old
      },
      {
        "nvim-lspconfig",
        opts = {
          servers = {
            yamlls = {
              on_new_config = function(new_config)
                new_config.settings.yaml.schemas = vim.tbl_deep_extend(
                  "force",
                  new_config.settings.yaml.schemas or {},
                  require("schemastore").yaml.schemas()
                )
              end,
              settings = {
                redhat = { telemetry = { enabled = false } },
                yaml = {
                  keyOrdering = false,
                  format = {
                    enable = true,
                  },
                  validate = true,
                  schemaStore = {
                    -- Must disable built-in schemaStore support to use
                    -- schemas from SchemaStore.nvim plugin
                    enable = false,
                    -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                    url = "",
                  },
                },
              },
            },
            jsonls = {
              on_new_config = function(new_config)
                new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
              end,
              settings = {
                json = {
                  validate = { enable = true },
                },
              },
            },
          },
        },
      },
      -- {
      --   "conform.nvim",
      --   opts = {
      --     formatters_by_ft = {
      --       json = { "biome-check", "prettier", stop_after_first = true },
      --       jsonc = { "biome-check", "prettier", stop_after_first = true },
      --     },
      --   },
      -- },
    }
  or {}
