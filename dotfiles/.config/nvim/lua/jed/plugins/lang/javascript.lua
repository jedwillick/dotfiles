local filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

return true
    and {
      {
        "nvim-treesitter",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "javascript",
            "typescript",
            "jsdoc",
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
        ft = filetypes,
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
      },

      {
        "conform.nvim",
        opts = function(_, opts)
          local fts = { "typescript", "typescriptreact", "javascript", "javascriptreact", "css", "json", "jsonc" }
          for _, ft in ipairs(fts) do
            opts.formatters_by_ft[ft] = { "biome-check", "prettier", stop_after_first = true }
          end
          return opts
        end,
      },
      {
        "nvim-lspconfig",
        opts = {
          servers = {
            cssls = {},
            css_variables = {
              settings = {
                cssVariables = {
                  lookupFiles = {
                    "**/*.css",
                    "**/*.scss",
                    "**/*.sass",
                    "**/*.less",
                    "node_modules/@mantine/core/styles.css",
                  },
                },
              },
            },
            biome = {
              prefer_local = { "npx" },
              keys = {
                {
                  "<leader>c?",
                  function()
                    local cursor_position = vim.api.nvim_win_get_cursor(0)
                    local line = cursor_position[1] - 1 -- Lines are 0-indexed in the API
                    local col = cursor_position[2]
                    local diagnostics = vim.diagnostic.get(0, { lnum = line })
                    if not #diagnostics then
                      return
                    end

                    local cur_diag = nil
                    for _, diag in ipairs(diagnostics) do
                      if diag.col <= col and col <= diag.end_col then
                        cur_diag = diag
                        break
                      end
                    end

                    if not cur_diag or not cur_diag.code then
                      return
                    end

                    local code = cur_diag.code:match("^.*/(.*)$")
                    local function to_kebab_case(str)
                      -- Replace each uppercase letter with '-lowercase_letter'
                      local kebab = str:gsub("%u", function(c)
                        return "-" .. c:lower()
                      end)
                      -- Remove leading dash if present
                      return kebab:match("^-") and kebab:sub(2) or kebab
                    end

                    local Job = require("plenary.job")
                    Job:new({
                      command = "wslview",
                      args = { "https://biomejs.dev/linter/rules/" .. to_kebab_case(code) },
                    }):start()
                    return {}
                  end,
                  desc = "Open documentation for diagnostic",
                },
              },
            },
            eslint = {
              prefer_local = { "npx" },
              handlers = {
                ["eslint/openDoc"] = function(_, result)
                  if not result then
                    return
                  end
                  local Job = require("plenary.job")
                  Job:new({
                    command = "wslview",
                    args = { result.url },
                  }):start()
                  return {}
                end,
              },
            },
          },
        },
      },
    }
  or {}
