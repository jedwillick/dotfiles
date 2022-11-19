local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  BOOTSTRAP = fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
end

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("packer_user_config", {}),
  desc = "Automatically recompile packer.",
  pattern = "plugins.lua",
  command = "source | PackerCompile",
})

return require("packer").startup(function(use)
  use { "wbthomason/packer.nvim" }

  use { "lewis6991/impatient.nvim", config = [[require('impatient')]] }

  use {
    "~/dev/version.nvim",
    config = function()
      require("version").setup {
        filetypes = {
          c = {
            prepend_exe = true,
          },
        },
      }
    end,
  }

  use {
    "folke/tokyonight.nvim",
    config = [[require("config/tokyonight")]],
  }

  use {
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    after = { "mason.nvim" },
    config = [[require('config/alpha')]],
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    requires = { "RRethy/nvim-treesitter-endwise", "nvim-treesitter/playground" },
    run = ":TSUpdate",
    config = [[require('config/treesitter')]],
  }

  use { "folke/neodev.nvim", config = [[require("neodev").setup()]] }

  use {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {
        window = { relative = "editor" },
        text = { spinner = "dots" },
      }
      -- HACK to stop error when exiting
      vim.api.nvim_create_autocmd("VimLeavePre", { command = [[silent! FidgetClose]] })
    end,
  }

  use {
    "williamboman/mason.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
      "p00f/clangd_extensions.nvim",
    },
    after = { "null-ls.nvim", "neodev.nvim", "fidget.nvim" },
    config = [[require('config/lsp')]],
  }

  use {
    "L3MON4D3/LuaSnip",
    requires = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  }

  use {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    requires = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "chrisgrieser/cmp-nerdfont",
      "saadparwaiz1/cmp_luasnip",
    },
    config = [[require('config/cmp')]],
  }

  use {
    "zbirenbaum/copilot.lua",
    event = "VimEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()
      end, 100)
    end,
  }

  use {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  }

  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
      local ft = require("Comment.ft")
      ft.plsql = "-- %s"
      ft.c = "// %s"
      ft.editorconfig = "; %s"
    end,
  }

  use {
    "akinsho/bufferline.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = [[require("config/bufferline")]],
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    config = [[require('config/lualine')]],
  }

  local colorizerFileTypes = { "css", "javascript", "html", "json", "yaml", "toml" }
  use {
    "norcalli/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    ft = colorizerFileTypes,
    setup = [[vim.keymap.set("n", "<leader>ct", "<cmd>ColorizerToggle<cr>")]],
    config = [[require("colorizer").setup(colorizerFileTypes)]],
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.opt.list = true
      require("indent_blankline").setup {
        char = "▏",
        show_trailing_blankline_indent = false,
        show_current_context = true,
      }
    end,
  }

  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "telescope-fzf-native.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = [[require('config/telescope')]],
  }

  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = [[require("config/neo-tree")]],
  }

  use { "dstein64/vim-startuptime", cmd = "StartupTime", config = [[vim.g.startuptime_tries = 10]] }

  use {
    "AndrewRadev/sideways.vim",
    cmd = { "SidewaysLeft", "SidewaysRight" },
    setup = function()
      vim.keymap.set("n", "<leader>h", ":SidewaysLeft<CR>")
      vim.keymap.set("n", "<leader>l", ":SidewaysRight<CR>")
    end,
  }

  use {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    setup = [[vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")]],
    config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
  }

  use {
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown" },
  }

  use {
    "gpanders/editorconfig.nvim",
    config = function()
      vim.api.nvim_create_user_command("EditorConfigConfig", function()
        vim.pretty_print(vim.b.editorconfig)
      end, { desc = "Show the editorconfig conifg" })

      local reload = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          require("editorconfig").config(buf)
        end
      end
      vim.api.nvim_create_user_command("EditorConfigReload", reload, { desc = "Reload editorconfig" })
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("editorconfig", { clear = false }),
        desc = "Automatically reload editorconfig",
        pattern = ".editorconfig",
        callback = reload,
      })
    end,
  }

  use { "folke/which-key.nvim", config = [[require("which-key").setup()]] }

  if BOOTSTRAP then
    require("packer").sync()
  end
end)
