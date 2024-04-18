local Format = require("jed.util.format")
local Lint = require("jed.util.lint")

return {
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
    "gpanders/editorconfig.nvim",
    lazy = false,
    enabled = function()
      return vim.fn.has("nvim-0.9") == 0
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          Format.format { lsp_fallback = true }
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
            Format.format { lsp_fallback = true }
          end
        end,
      })
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
    end,
    opts = {
      source_selector = {
        winbar = true,
      },
      window = {
        mappings = {
          ["<space>"] = false,
        },
      },
      filesystem = {
        follow_current_file = true,
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
}
