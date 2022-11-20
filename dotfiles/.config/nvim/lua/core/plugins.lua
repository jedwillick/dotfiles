local function config(name)
  return string.format([[require("plugins.%s")]], name)
end

local plugins = function(use)
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
    config = config("tokyonight"),
  }

  use {
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    after = { "mason.nvim" },
    config = config("alpha"),
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    requires = { "RRethy/nvim-treesitter-endwise", "nvim-treesitter/playground" },
    run = ":TSUpdate",
    config = config("treesitter"),
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
      {
        "SmiteshP/nvim-navic",
        config = function()
          require("nvim-navic").setup {
            depth_limit = 5,
            separator = "  ",
          }
        end,
      },
    },
    after = { "null-ls.nvim", "neodev.nvim", "fidget.nvim" },
    config = config("lsp"),
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
    config = config("cmp"),
  }

  use {
    "zbirenbaum/copilot.lua",
    requires = { "zbirenbaum/copilot-cmp" },
    event = "VimEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()
        require("copilot_cmp").setup()
      end, 100)
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
    config = config("bufferline"),
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    config = config("lualine"),
  }

  local colorizerFileTypes = { "css", "javascript", "html", "json", "yaml", "toml" }
  use {
    "norcalli/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    ft = colorizerFileTypes,
    setup = function()
      vim.keymap.set("n", "<leader>ct", "<cmd>ColorizerToggle<cr>")
    end,
    config = function()
      require("colorizer").setup(colorizerFileTypes)
    end,
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
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
    config = config("telescope"),
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
    config = config("neo-tree"),
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
    config = config("editorconfig"),
  }

  use { "folke/which-key.nvim", config = [[require("which-key").setup()]] }

  use { "famiu/bufdelete.nvim" }
end

require("plugins.packer").setup(plugins)
