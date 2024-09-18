return true
  and {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, {
          "c",
          "cpp",
          "cmake",
          "make",
        })
      end,
    },
    {
      "mason.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, {
          "clangd",
          "clang-format",
          "neocmakelsp",
        })
      end,
    },
    {
      "p00f/clangd_extensions.nvim",
      lazy = true,
      opts = {
        ast = {
          role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
          },
          kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
          },
        },
      },
    },
    {
      "nvim-lspconfig",
      opts = {
        servers = {
          neocmake = {},
          clangd = {
            capabilities = { offsetEncoding = "utf-16" },
          },
        },
      },
    },
    {
      "nvim-cmp",
      opts = function(_, opts)
        table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
      end,
    },
  }
