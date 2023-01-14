return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
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
      { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
      "hrsh7th/cmp-nvim-lsp",
      "p00f/clangd_extensions.nvim",
      "b0o/schemastore.nvim",
    },
    config = function()
      local servers = {
        bashls = { cmd_env = { SHELLCHECK_PATH = "" } },
        clangd = { -- Will be passed to clangd_extensions
          server = {},
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
        sumneko_lua = {
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

      require("jed.util").on_attach(function(client, buf)
        client.server_capabilities.semanticTokensProvider = nil
        require("jed.plugins.lsp.formatting").on_attach(client, buf)
        require("jed.plugins.lsp.keys").on_attach(client, buf)
      end)

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      for lsp, opts in pairs(servers) do
        if lsp == "clangd" then
          opts.server.capabilities = capabilities
          opts.server.capabilities.offsetEncoding = "utf-8"
          require("clangd_extensions").setup(opts)
        else
          opts.capabilities = capabilities
          require("lspconfig")[lsp].setup(opts)
        end
      end
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
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
            extra_args = { "--indent=2", "--case-indent", "--binary-next-line", "--space-redirects" },
            runtime_condition = function()
              ---@diagnostic disable-next-line: undefined-field
              return not vim.b.editorconfig
            end,
          },
          fmt.shfmt.with {
            runtime_condition = function()
              ---@diagnostic disable-next-line: undefined-field
              return vim.b.editorconfig
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
        },
      }
      -- Auto-install null-ls sources
      local mr = require("mason-registry")
      local sources = nls.get_sources()
      for _, source in ipairs(sources) do
        local ok, p = pcall(mr.get_package, source.name:gsub("_", "-"))
        if ok and not p:is_installed() then
          p:install()
        end
      end
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "BufReadPre",
    opts = {
      window = { relative = "editor" },
      text = { spinner = "dots" },
    },
  },
  {
    "SmiteshP/nvim-navic",
    init = function()
      require("jed.util").on_attach(function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, bufnr)
        end
      end)
    end,
    opts = {
      depth_limit = 5,
      separator = "  ",
      highlight = true,
    },
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
}
