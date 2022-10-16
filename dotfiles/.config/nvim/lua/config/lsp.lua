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

local telescope = require("telescope.builtin")
local set = vim.keymap.set
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format {
    filter = function(client)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  }
end

local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  set("n", "gD", vim.lsp.buf.declaration, bufopts)
  set("n", "gd", telescope.lsp_definitions, bufopts)
  set("n", "K", vim.lsp.buf.hover, bufopts)
  set("n", "gi", telescope.lsp_implementations, bufopts)
  set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
  set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)
  set("n", "gr", telescope.lsp_references, bufopts)
  set("n", "<leader>fd", telescope.diagnostics, bufopts)
  set("n", "[d", vim.diagnostic.goto_prev, bufopts)
  set("n", "]d", vim.diagnostic.goto_next, bufopts)

  if client.supports_method("textDocument/formatting") then
    set("n", "<leader>bf", lsp_formatting, bufopts)
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
      },
    },
  },
  vimls = {},
  yamlls = {},
}

local lspconfig = require("lspconfig")
local coq = require("coq")

local baseConfig = {
  on_attach = on_attach,
}

for lsp, config in pairs(servers) do
  lspconfig[lsp].setup(coq.lsp_ensure_capabilities(vim.tbl_deep_extend("keep", config, baseConfig)))
end

local null_ls = require("null-ls")
local fmt = null_ls.builtins.formatting
local diag = null_ls.builtins.diagnostics
local act = null_ls.builtins.code_actions

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
null_ls.setup {
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

    diag.editorconfig_checker.with {
      command = "editorconfig-checker",
      condition = with_editorconfig,
    },
    fmt.trim_whitespace.with {
      condition = without_editorconifg,
      disabled_filetypes = { "markdown" },
    },
    fmt.trim_newlines,
  },
}

-- Auto-install null-ls sources
local mr = require("mason-registry")
local sources = null_ls.get_sources()
for _, source in ipairs(sources) do
  local ok, p = pcall(mr.get_package, source.name:gsub("_", "-"))
  if ok and not p:is_installed() then
    p:install()
  end
end
