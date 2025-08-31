local Format = require("jed.util.format")
local Lint = require("jed.util.lint")

return {
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    config = {},
  },

  {
    "amitds1997/remote-nvim.nvim",
    enabled = false,
    version = "v0.3.9",
    dependencies = {
      "nvim-lua/plenary.nvim", -- For standard functions
      "MunifTanjim/nui.nvim", -- To build the plugin UI
      "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    config = true,
  },

  {
    "ggandor/leap.nvim",
    event = "User VeryLazy",
    dependencies = { "ggandor/flit.nvim" },
    config = function()
      require("leap").add_default_mappings()
      require("flit").setup {
        labeled_modes = "nv",
      }
    end,
  },
  -- {
  --   "folke/flash.nvim",
  --   event = "VeryLazy",
  --   ---@type Flash.Config
  --   opts = {
  --     modes = {
  --       search = {
  --         enabled = false,
  --       },
  --     },
  --   },
  -- -- stylua: ignore
  --   keys = {
  --     { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --     { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  --     { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  --     { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  --     { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  --   },
  -- },
  {
    "andymass/vim-matchup",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },
  {
    "nvim-pack/nvim-spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      {
        "<leader>rr",
        function()
          require("spectre").open()
        end,
        desc = "Replace (Spectre)",
      },
      {
        "<leader>rw",
        function()
          require("spectre").open_visual { select_word = true }
        end,
        desc = "Replace current word (Spectre)",
      },
      {
        "<leader>r",
        function()
          require("spectre").open_visual { select_word = true }
        end,
        desc = "Replace current selection (Spectre)",
        mode = { "v" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          Format.format { lsp_format = "fallback" }
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
      {
        "<leader>uf",
        function()
          Format.toggle()
        end,
        mode = { "n" },
        desc = "Toggle autoformat (global)",
      },
      {
        "<leader>uF",
        function()
          Format.toggle(true)
        end,
        mode = { "n" },
        desc = "Toggle autoformat (buffer)",
      },
    },
    opts = function()
      vim.g.autoformat = true
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          if Format.enabled() then
            Format.format()
          end
        end,
      })
      return { default_format_opts = {
        lsp_format = "fallback",
      } }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    keys = {

      {
        "<leader>ul",
        function()
          Lint.toggle()
        end,
        mode = { "n" },
        desc = "Toggle autolint (global)",
      },
      {
        "<leader>uL",
        function()
          Lint.toggle(true)
        end,
        mode = { "n" },
        desc = "Toggle autolint (buffer)",
      },
    },
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        -- markdown = { "markdownlint" },
        -- Use the "*" filetype to run linters on all filetypes.
        -- ["*"] = { "shellcheck" },
        -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
        -- ['_'] = { 'fallback linter' },
      },
      ---@type table<string,table>
      linters = {
        -- Override linter options
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
        else
          lint.linters[name] = linter
        end
      end
      lint.linters_by_ft = opts.linters_by_ft

      vim.g.autolint = true

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = Lint.debounce(100, function()
          if Lint.enabled() then
            Lint.lint()
          end
        end),
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    keys = {
      { "<leader>M", "<cmd>Mason<cr>" },
    },
    cmd = { "Mason", "MasonUpdate" },
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      install_root_dir = os.getenv("HOME") .. "/.local",
      ensure_installed = {
        -- -- Go
        -- "golangci-lint",
        -- "gopls",
        -- -- Others
        -- "vim-language-server",
        -- "typst-lsp",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          vim.api.nvim_exec_autocmds("FileType", { buffer = vim.api.nvim_get_current_buf() })
        end, 100)
      end)
      local tool, version
      mr.refresh(function()
        for _, ensure in ipairs(opts.ensure_installed) do
          if type(ensure) == "table" then
            tool = ensure[1]
            version = ensure.version
          else
            tool = ensure
            version = nil
          end
          local status, p = pcall(mr.get_package, tool)
          if status and not p:is_installed() then
            p:install({ version = version }):once(
              "closed",
              vim.schedule_wrap(function()
                p:get_installed_version(function(success, ver)
                  ver = success and ver or "BAD"
                  if p:is_installed() then
                    vim.notify(("Installed %s v%s"):format(p.name, ver))
                  else
                    vim.notify(("Failed to install %s v%s"):format(p.name, ver), vim.log.levels.WARN)
                  end
                end)
              end)
            )
          end
        end
      end)
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      { [[\]], "<cmd>Neotree<cr>" },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      -- vim.api.nvim_create_autocmd("BufRead", {
      --   callback = function()
      --     -- Open Neo-tree if it's not already open
      --     if not vim.g.neo_tree_open then
      --       vim.cmd("Neotree  show")
      --       vim.g.neo_tree_open = true
      --     end
      --   end,
      -- })
    end,
    opts = {
      event_handlers = {

        {
          event = "neo_tree_window_after_open",
          handler = function(_)
            vim.cmd("wincmd =")
          end,
        },
      },
      close_if_last_window = true,
      source_selector = {
        winbar = true,
      },
      window = {
        width = 40,
        mappings = {
          ["<space>"] = false,
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true
        },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_by_name = {
            ".git",
            ".svn",
          },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      {
        "<leader>nn",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
      },
      {
        "<leader>gf",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Current File History",
      },
      {
        "<leader>gl",
        function()
          Snacks.lazygit.log()
        end,
        desc = "Lazygit Log (cwd)",
      },
      {
        "<leader>cR",
        function()
          Snacks.rename()
        end,
        desc = "Rename File",
      },
      {
        "<c-/>",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle Terminal",
      },
      {
        "<c-_>",
        function()
          Snacks.terminal()
        end,
        desc = "which_key_ignore",
      },
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
      },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win {
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          }
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
        end,
      })
    end,
  },
}
