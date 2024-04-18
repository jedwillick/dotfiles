return false
    and {
      {
        "nvim-treesitter",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "java",
          })
        end,
      },
      {
        "mason.nvim",
        opts = function(_, opts)
          opts.registries = opts.registries or { "github:mason-org/mason-registry" }
          table.insert(opts.registries, 1, "github:nvim-java/mason-registry")
        end,
      },
      {
        "nvim-lspconfig",
        dependencies = {
          "nvim-java",
        },
        opts = {
          servers = {
            jdtls = {},
          },
        },
      },
      {
        "nvim-java/nvim-java",
        dependencies = {
          "nvim-java/lua-async-await",
          "nvim-java/nvim-java-core",
          "nvim-java/nvim-java-test",
          "nvim-java/nvim-java-dap",
          "mfussenegger/nvim-dap",
        },
        opts = {},
      },
    }
  or {}
