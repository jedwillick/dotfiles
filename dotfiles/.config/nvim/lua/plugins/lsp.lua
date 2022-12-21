require("mason").setup {
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
  -- install_root_dir = os.getenv("HOME") .. "/.local",
}

require("mason-lspconfig").setup {
  automatic_installation = true,
}

local nls = require("null-ls")

local set = vim.keymap.set
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  vim.lsp.buf.format {
    filter = function(client)
      if #require("null-ls.sources").get_available(ft, nls.methods.FORMATTING) > 0 then
        return client.name == "null-ls"
      else
        return not (client.name == "null-ls")
      end
    end,
    bufnr = bufnr,
  }
end

local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  set("n", "gD", vim.lsp.buf.declaration, bufopts)
  set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", bufopts)
  set("n", "K", vim.lsp.buf.hover, bufopts)
  set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", bufopts)
  set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
  set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)
  set("n", "gr", "<cmd>Telescope lsp_references<cr>", bufopts)
  set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", bufopts)
  set("n", "[d", vim.diagnostic.goto_prev, bufopts)
  set("n", "]d", vim.diagnostic.goto_next, bufopts)

  if client.supports_method("textDocument/formatting") then
    set({ "n", "v" }, "<leader>cf", function()
      lsp_formatting(bufnr)
    end, bufopts)
    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        lsp_formatting(bufnr)
      end,
    })
  end
end

local servers = {
  bashls = { cmd_env = { SHELLCHECK_PATH = "" } },
  clangd = { capabilities = { offsetEncoding = "utf-8" } },
  gopls = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
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

local lspconfig = require("lspconfig")

local baseConfig = {
  on_attach = on_attach,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

local lspBaseConfig = vim.tbl_extend("force", baseConfig, {
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      require("nvim-navic").attach(client, bufnr)
    end
    baseConfig.on_attach(client, bufnr)
  end,
})

for lsp, config in pairs(servers) do
  if lsp ~= "clangd" then
    lspconfig[lsp].setup(vim.tbl_deep_extend("force", lspBaseConfig, config))
  end
end

require("clangd_extensions").setup {
  server = vim.tbl_deep_extend("force", lspBaseConfig, servers.clangd),
  extensions = {
    -- defaults:
    -- Automatically set inlay hints (type hints)
    autoSetHints = false,
    -- These apply to the default ClangdSetInlayHints command
    inlay_hints = {
      -- Only show inlay hints for the current line
      only_current_line = false,
      -- Event which triggers a refersh of the inlay hints.
      -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
      -- not that this may cause  higher CPU usage.
      -- This option is only respected when only_current_line and
      -- autoSetHints both are true.
      only_current_line_autocmd = "CursorHold",
      -- whether to show parameter hints with the inlay hints or not
      show_parameter_hints = true,
      -- prefix for parameter hints
      parameter_hints_prefix = "<- ",
      -- prefix for all the other hints (type, chaining)
      other_hints_prefix = "=> ",
      -- whether to align to the length of the longest line in the file
      max_len_align = false,
      -- padding from the left if max_len_align is true
      max_len_align_padding = 1,
      -- whether to align to the extreme right or not
      right_align = false,
      -- padding from the right if right_align is true
      right_align_padding = 7,
      -- The color of the hints
      highlight = "Comment",
      -- The highlight group priority for extmark
      priority = 100,
    },
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

      highlights = {
        detail = "Comment",
      },
    },
    memory_usage = {
      border = "none",
    },
    symbol_info = {
      border = "none",
    },
  },
}

local fmt = nls.builtins.formatting
local diag = nls.builtins.diagnostics
local act = nls.builtins.code_actions

local shellcheck = { extra_args = { "--exclude=1090,1091" } }

local with_root_file = function(...)
  local files = { ... }
  return function(utils)
    return utils.root_has_file(files)
  end
end

local without_root_file = function(...)
  local files = { ... }
  return function(utils)
    return not utils.root_has_file(files)
  end
end

local with_editorconfig = with_root_file(".editorconfig")
local without_editorconifg = without_root_file(".editorconfig")
local stylua = { "stylua.toml", ".stylua.toml" }
nls.setup {
  on_attach = on_attach,
  root_dir = require("null-ls.utils").root_pattern(
    ".null-ls-root",
    ".git",
    ".svn",
    "Makefile",
    ".editorconfig",
    stylua
  ),
  sources = {
    fmt.shfmt.with { -- If no editorconifg these defaults will be used.
      extra_args = { "--indent=2", "--case-indent", "--binary-next-line", "--space-redirects" },
      condition = without_editorconifg,
    },
    fmt.shfmt.with {
      condition = with_editorconfig,
    },

    act.shellcheck.with(shellcheck),
    diag.shellcheck.with(shellcheck),

    fmt.gofmt,
    diag.golangci_lint,

    -- Python
    fmt.black,
    fmt.isort.with {
      extra_args = { "--profile=black" },
    },
    diag.flake8.with {
      extra_args = { "--max-line-length=88", "--ignore=E203,W503" },
    },

    fmt.stylua.with {
      condition = with_root_file(stylua),
    },

    fmt.clang_format,

    diag.markdownlint,
    fmt.markdownlint,
    fmt.prettier,

    -- fmt.trim_whitespace.with {
    --   condition = without_editorconifg,
    --   disabled_filetypes = { "markdown" },
    -- },

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
