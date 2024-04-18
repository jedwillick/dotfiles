return {
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
      local ft = require("Comment.ft")
      ft.plsql = "-- %s"
      -- ft.c = "// %s"
      -- ft.editorconfig = "; %s"
    end,
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "windwp/nvim-autopairs",
    opts = { check_ts = true },
    event = "InsertEnter",
  },
  {
    "echasnovski/mini.surround",
    event = "User VeryLazy",
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  {
    "danymat/neogen",
    cmd = "Neogen",
    keys = {
      { "<leader>cd", "<cmd>Neogen<cr>", desc = "Generate docstring" },
    },
    opts = {
      snippet_engine = "luasnip",
    },
  },
  -- {
  --   "kylechui/nvim-surround",
  --   event = "User VeryLazy",
  --   config = true,
  -- },
  -- {
  --   "echasnovski/mini.ai",
  --   event = "User VeryLazy",
  --   opts = function()
  --     local ns_utils = require("nvim-surround.utils")
  --
  --     local function ns_alias_mini_ai(alias)
  --       return function(mode)
  --         local s = ns_utils.get_nearest_selections(alias, "change")
  --         if not s then
  --           return
  --         end
  --         local f_col = s.left.first_pos[2] + (mode == "i" and 1 or 0)
  --         local t_col = s.right.last_pos[2] + (mode == "i" and -1 or 0)
  --         local region = {
  --           from = { line = s.left.first_pos[1], col = f_col },
  --           to = { line = s.right.last_pos[1], col = t_col },
  --         }
  --         return region
  --       end
  --     end
  --
  --     local custom_textobjects = {}
  --     for alias, _ in pairs(require("nvim-surround.config").get_opts().aliases) do
  --       custom_textobjects[alias] = ns_alias_mini_ai(alias)
  --     end
  --
  --     return {
  --       custom_textobjects = custom_textobjects,
  --       silent = true,
  --     }
  --   end,
  -- },
  {
    "zbirenbaum/copilot-cmp",
    enabled = false,
    event = "VeryLazy",
    config = true,
    dependencies = {
      "zbirenbaum/copilot.lua",
      opts = {
        filetypes = {
          TelescopePrompt = false,
          man = false,
        },
        suggestion = { enabled = false },
        panel = { enabled = false },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<tab>",
        function()
          require("luasnip").jump(1)
        end,
        mode = "s",
      },
      {
        "<s-tab>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = { "i", "s" },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      { "hrsh7th/cmp-nvim-lsp-signature-help", enabled = false },
      "chrisgrieser/cmp-nerdfont",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Todo", default = true })

      local cmp = require("cmp")

      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete {},
          ["<C-e>"] = cmp.mapping.abort(),
          -- ["<Tab>"] = cmp.mapping(function(fallback)
          --   -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
          --   if cmp.visible() then
          --     local entry = cmp.get_selected_entry()
          --     if not entry then
          --       cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
          --     else
          --       cmp.confirm()
          --     end
          --   else
          --     fallback()
          --   end
          -- end, { "i", "s" }),
          ["<CR>"] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
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
  },
}
