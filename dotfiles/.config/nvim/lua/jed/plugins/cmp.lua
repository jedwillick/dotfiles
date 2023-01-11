return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "onsails/lspkind.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "chrisgrieser/cmp-nerdfont",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup {
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete {},
        ["<C-e>"] = cmp.mapping.close(),
        ["<Tab>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
      },
      experimental = {
        ghost_text = true,
      },
      formatting = {
        format = require("lspkind").cmp_format {
          symbol_map = { Copilot = "" },
          mode = "symbol_text",
          menu = {
            nvim_lsp = "[LSP]",
            luasnip = "[SNIP]",
            buffer = "[BUF]",
            path = "[PATH]",
            calc = "[CALC]",
            nerdfont = "[NF]",
            copilot = "[COP]",
            nvim_lsp_signature_help = "[SIG]",
          },
        },
      },
      sources = cmp.config.sources {
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp" },
        { name = "copilot" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "calc" },
        { name = "nerdfont" },
      },
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          require("clangd_extensions.cmp_scores"),
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
    }
  end,
}
