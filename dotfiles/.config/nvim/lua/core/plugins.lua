local function config(name)
  return string.format([[require("plugins.%s")]], name)
end

local plugins = function(use)
  use { "wbthomason/packer.nvim" }

  use { "lewis6991/impatient.nvim" }

  use {
    "~/dev/version.nvim",
    config = function()
      require("version").setup {}
    end,
    event = "BufReadPre",
  }

  use {
    "nvim-lua/plenary.nvim",
  }

  use {
    "folke/tokyonight.nvim",
    config = config("tokyonight"),
    opt = false,
  }

  use {
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = config("alpha"),
    event = "VimEnter",
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    requires = {
      "RRethy/nvim-treesitter-endwise",
      "nvim-treesitter/playground",
    },
    run = function()
      require("nvim-treesitter.install").update { with_sync = true }
    end,
    config = config("treesitter"),
  }

  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup { check_ts = true }
    end,
    event = "InsertEnter",
  }

  use {
    "folke/neodev.nvim",
    config = [[require("neodev").setup()]],
  }

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
      "jose-elias-alvarez/null-ls.nvim",
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
    after = { "neodev.nvim", "fidget.nvim" },
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
        require("copilot").setup {
          filetypes = {
            TelescopePrompt = false,
            man = false,
          },
        }
        require("copilot_cmp").setup()
      end, 100)
    end,
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
    event = "BufReadPre",
  }

  use {
    "akinsho/bufferline.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = config("bufferline"),
    event = "BufReadPre",
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    config = config("lualine"),
    event = "VimEnter",
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
    event = "BufReadPre",
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
    event = "VimEnter",
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
    cmd = "Neotree",
    keys = [[\]],
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
    event = "VimEnter",
  }

  use {
    "folke/which-key.nvim",
    config = [[require("which-key").setup()]],
    event = "User PackerDefered",
  }

  use {
    "famiu/bufdelete.nvim",
    event = "BufReadPre",
  }

  use {
    "akinsho/toggleterm.nvim",
    config = config("toggleterm"),
    event = "User PackerDefered",
  }

  use {
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  }

  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
    event = "BufReadPre",
  }
end
require("plugins.packer").setup(plugins)
