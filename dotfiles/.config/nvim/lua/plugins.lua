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
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup {
        style = "storm",
        styles = {
          keywords = "NONE",
          comments = "NONE",
        },
        sidebars = { "qf", "vista_kind", "terminal", "packer", "chadtree" },
      }
      vim.cmd("colorscheme tokyonight")
      vim.cmd("colorscheme tokyonight") -- Need to set it twice for bufferline
    end,
  }

  use {
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    after = { "mason.nvim" },
    config = [[require('config/alpha')]],
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    requires = { "RRethy/nvim-treesitter-endwise" },
    run = ":TSUpdate",
    config = [[require('config/treesitter')]],
  }

  use { "folke/lua-dev.nvim", config = [[require("lua-dev").setup()]] }

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
      -- "p00f/clangd_extensions.nvim",
    },
    after = { "coq_nvim", "null-ls.nvim", "lua-dev.nvim", "fidget.nvim" },
    config = [[require('config/lsp')]],
  }

  use {
    "ms-jpq/coq_nvim",
    requires = {
      { "ms-jpq/coq.artifacts", branch = "artifacts" },
      { "ms-jpq/coq.thirdparty", branch = "3p" },
    },
    run = ":COQdeps",
    config = function()
      vim.g.coq_settings = { auto_start = "shut-up" }
      require("coq_3p") {
        { src = "copilot", short_name = "COP", accept_key = "<c-j>" },
        -- { src = "nvimlua", short_name = "nLUA", conf_only = false },
      }
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
      vim.opt.listchars:append("space:⋅")
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
    "ms-jpq/chadtree",
    branch = "chad",
    run = { "python3 -m chadtree deps", ":CHADdeps" },
    cmd = { "CHADopen" },
    setup = [[vim.keymap.set("n", "<leader>t", ":CHADopen<cr>")]],
    config = function()
      local chadtree_settings = { ["keymap.tertiary"] = { "<c-t>", "<middlemouse>" } }
      vim.api.nvim_set_var("chadtree_settings", chadtree_settings)
    end,
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
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set(
        "i",
        "<C-j>",
        [[copilot#Accept("<CR>")]],
        { silent = true, script = true, expr = true, replace_keycodes = false }
      )
      vim.g.copilot_filetypes = {
        TelescopePrompt = false,
      }
    end,
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
