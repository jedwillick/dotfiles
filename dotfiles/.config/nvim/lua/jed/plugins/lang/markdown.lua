local parsers = {
  require("lint.parser").from_pattern(
    [[^stdin:(%d+):(%d+) ([%w-/]+) (.*)$]],
    { "lnum", "col", "code", "message" },
    nil,
    { severity = vim.diagnostic.severity.WARN, source = "markdownlint" }
  ),
  require("lint.parser").from_pattern(
    [[^stdin:(%d+) ([%w-/]+) (.*)$]],
    { "lnum", "code", "message" },
    nil,
    { severity = vim.diagnostic.severity.WARN, source = "markdownlint" }
  ),
}

return true
    and {
      {
        "nvim-treesitter",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "markdown",
            "markdown_inline",
          })
        end,
      },
      {
        "nvim-lspconfig",
        opts = {
          servers = {
            vale_ls = {},
          },
        },
      },
      {
        "mason.nvim",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "markdownlint",
            "vale",
            "vale-ls",
          })
        end,
      },
      {
        "iamcco/markdown-preview.nvim",
        ft = { "markdown" },
        build = function()
          vim.fn["mkdp#util#install"]()
        end,
      },
      {
        "conform.nvim",
        opts = {
          formatters_by_ft = {
            markdown = { "markdownlint" },
          },
        },
      },
      {
        "nvim-lint",
        opts = {
          linters_by_ft = {
            markdown = { "markdownlint" },
          },
          linters = {
            markdownlint = {
              stdin = true,
              args = { "--stdin" },
              parser = function(output, bufnr)
                local diagnostics = {}
                for _, parser in ipairs(parsers) do
                  local result = parser(output, bufnr)
                  for _, diagnostic in ipairs(result) do
                    table.insert(diagnostics, diagnostic)
                  end
                end

                return diagnostics
              end,
            },
          },
        },
      },
    }
  or {}
