return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      {
        "folke/neodev.nvim",
        opts = {
          override = function(root_dir, library)
            local dots = os.getenv("DOTFILES")
            if root_dir == dots or root_dir == dots .. "/dotfiles/.config/nvim" then
              library.enable = true
              library.plugins = true
            end
          end,
        },
      },
      "hrsh7th/cmp-nvim-lsp",
      "p00f/clangd_extensions.nvim",
      "b0o/schemastore.nvim",
      "mrcjkb/haskell-tools.nvim",
      "mason.nvim",
    },
    config = function()
      local servers = {
        bashls = { cmd_env = { SHELLCHECK_PATH = "" } },
        clangd = { -- Will be passed to clangd_extensions
          server = { capabilities = { offsetEncoding = "utf-16" } },
          extensions = {
            autoSetHints = false,
            ast = {
              role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
              },
              kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
              },
            },
          },
        },
        gopls = {},
        hls = {
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
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              validate = { enable = true },
            },
          },
        },
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false,
              },
              telemetry = {
                enable = false,
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        vimls = {},
        yamlls = {},
      }

      local default_on_codelens = vim.lsp.codelens.on_codelens
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.codelens.on_codelens = function(err, lenses, ctx, _)
        if err or not lenses or not next(lenses) then
          return default_on_codelens(err, lenses, ctx, _)
        end
        for _, lens in pairs(lenses) do
          if lens and lens.command and lens.command.title then
            lens.command.title = "     " .. lens.command.title
          end
        end
        return default_on_codelens(err, lenses, ctx, _)
      end

      require("jed.util").on_attach(function(client, buf)
        -- client.server_capabilities.semanticTokensProvider = nil
        require("jed.plugins.lsp.formatting").on_attach(client, buf)
        require("jed.plugins.lsp.keys").on_attach(client, buf)
      end)

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      for lsp, opts in pairs(servers) do
        capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities or {})
        if lsp == "clangd" then
          require("clangd_extensions").setup(opts)
        elseif lsp == "hls" then
          require("haskell-tools").setup(opts)
        else
          require("lspconfig")[lsp].setup(opts)
        end
      end
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "mason.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local nls = require("null-ls")
      local fmt = nls.builtins.formatting
      local diag = nls.builtins.diagnostics
      local act = nls.builtins.code_actions
      -- local hover = nls.builtins.hover
      -- local cmp = nls.builtins.completion

      local shellcheck = { extra_args = { "--exclude=1090,1091" } }

      nls.setup {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".git", ".svn", "Makefile", ".editorconfig"),
        sources = {
          fmt.shfmt.with { -- If no editorconifg these defaults will be used.
            name = "shfmt default",
            extra_args = { "--indent=2", "--case-indent", "--binary-next-line", "--space-redirects" },
            condition = function()
              ---@diagnostic disable-next-line: undefined-field
              return vim.tbl_isempty(vim.b.editorconfig or {})
            end,
          },
          fmt.shfmt.with {
            name = "shfmt editorconfig",
            condition = function()
              ---@diagnostic disable-next-line: undefined-field
              return not vim.tbl_isempty(vim.b.editorconfig or {})
            end,
          },

          act.shellcheck.with(shellcheck),
          diag.shellcheck.with(shellcheck),

          fmt.gofmt,
          diag.golangci_lint,

          fmt.black,
          fmt.isort.with {
            extra_args = { "--profile=black" },
          },
          diag.flake8.with {
            extra_args = { "--max-line-length=88", "--ignore=E203,W503" },
          },

          fmt.stylua,

          fmt.clang_format,

          diag.markdownlint,
          fmt.markdownlint,
          fmt.prettier,

          act.gitsigns,

          diag.fish,
          fmt.fish_indent,
        },
      }
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      window = { relative = "editor" },
      text = { spinner = "dots" },
    },
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
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
}
