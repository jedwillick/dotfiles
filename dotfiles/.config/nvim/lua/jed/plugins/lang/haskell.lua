return false
    and {
      {
        "nvim-treesitter",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "haskell",
          })
        end,
      },
      {
        "mrcjkb/haskell-tools.nvim",
        ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
      },
      {
        "nvim-lspconfig",
        opts = {
          servers = {
            hls = { -- lsp config sets this to vim.g.haskell_tools
              keys = {
                {
                  "<leader>ch",
                  function()
                    require("haskell-tools").hoogle.hoogle_signature()
                  end,
                  desc = "Search Hoogle (Signature)",
                },
                {
                  "<leader>cH",
                  function()
                    require("haskell-tools").hoogle.hoogle_signature { search_term = vim.fn.expand("<cword>") }
                  end,
                  desc = "Search Hoogle (Current word)",
                },
              },
              hls = {
                settings = {
                  haskell = { formattingProvider = "ormolu" },
                },
              },
              tools = {
                hover = {
                  disable = true,
                },
                repl = {
                  handler = "toggleterm",
                },
              },
            },
          },
        },
      },
    }
  or {}
