return {
  "kyazdani42/nvim-web-devicons",
  "MunifTanjim/nui.nvim",

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- char = "▏",
      --      char = "│",
      --    context_char = "│",
      --  show_trailing_blankline_indent = false,
      --show_current_context = true,
    },
    config = function()
      require("ibl").setup {
        indent = { char = "│" },
        scope = {
          enabled = true,
          show_start = false,
          show_end = false,
          highlight = "IndentBlanklineContextChar",
        },
      }
    end,
  },
  {
    "rcarriga/nvim-notify",
    lazy = false,
    -- event = "VeryLazy",
    keys = {
      {
        "<leader>nn",
        function()
          require("notify").dismiss { silent = true, pending = true }
        end,
        desc = "Dismiss all notifications",
      },
    },
    config = function()
      require("notify").setup {
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
        stages = "slide",
      }
      vim.notify = require("notify")
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    -- event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("scrollbar").setup {
        excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "notify" },
      }
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
  {
    "lewis6991/satellite.nvim",
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      handlers = { marks = { enable = false } },
      excluded_filetypes = { "neo-tree" },
    },
  },
  {
    "j-hui/fidget.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
  {
    "utilyre/barbecue.nvim",
    opts = {},
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "SmiteshP/nvim-navic",
      opts = {
        depth_limit = 5,
        separator = "  ",
        highlight = true,
      },
    },
  },
  {
    -- Mainly just using it for nice docs and notify
    "folke/noice.nvim",
    cmd = "Noice",
    event = "VeryLazy",
    keys = {
      { "<leader>nl", "<cmd>Noice last<cr>", desc = "Noice Last Message" },
      { "<leader>nh", "<cmd>Noice history<cr>", desc = "Noice History" },
      { "<leader>nt", "<cmd>Noice telescope<cr>", desc = "Noice Telescope" },

      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
      },
    },
    opts = {
      presets = {
        long_message_to_split = true,
        inc_rename = true,
      },
      -- cmdline = { view = "cmdline" },
      cmdline = { enabled = false },
      messages = { enabled = false },
      popupmenu = { enabled = false },
      lsp = {
        progress = { enabled = false },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      views = {
        mini = {
          position = { row = -2 },
          win_options = { winblend = 100 },
        },
      },
      commands = {
        history = { view = "popup" },
        last = { view = "popup" },
        errors = { view = "popup" },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            find = "%d+L, %d+B",
          },
          view = "mini",
        },
        {
          view = "notify",
          filter = { event = "msg_showmode" },
        },
      },
    },
  },
  {
    "goolord/alpha-nvim",
    cmd = "Alpha",
    keys = {
      {
        "<leader>A",
        function()
          vim.cmd.Alpha()
          for _, e in ipairs(require("bufferline").get_elements().elements) do
            vim.schedule(function()
              if e.id == vim.api.nvim_get_current_buf() then
                return
              else
                vim.cmd("bd " .. e.id)
              end
            end)
          end
        end,
        desc = "Alpha",
      },
    },
    event = "VimEnter",
    config = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = string.format(
        [[
 _______                    .__
 \      \   ____  _______  _|__| _____
 /   |   \_/ __ \/  _ \  \/ /  |/     \
/    |    \  ___(  <_> )   /|  |  Y Y  \
\____|__  /\___  >____/ \_/ |__|__|_|  /
        \/     \/                    \/   %s]],
        tostring(vim.version())
      )

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("n", " " .. " New file", "<cmd>ene <bar> startinsert <cr>"),
        dashboard.button("SPC f f", " " .. " Find file"),
        dashboard.button("SPC f o", " " .. " Old files"),
        dashboard.button("SPC f g", " " .. " Grep files"),
        dashboard.button("SPC f s", " " .. " Sessions"),
        dashboard.button("SPC f p", " " .. " Projects"),
        dashboard.button("SPC L", "鈴" .. " Lazy"),
        dashboard.button("q", " " .. " Quit", "<cmd>qa<cr>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 8
      vim.b.miniindentscope_disable = true

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          once = true,
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          dashboard.section.footer.val =
            string.format("⚡ Lazy loaded %d plugins in %.2f ms", stats.count, stats.startuptime)
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
