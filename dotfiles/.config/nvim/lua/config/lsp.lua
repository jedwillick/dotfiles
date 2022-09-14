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
  jsonls = {},
  pyright = {},
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
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

null_ls.setup {
  sources = {
    fmt.shfmt.with {
      extra_args = { "--indent=2", "--case-indent", "--binary-next-line", "--space-redirects" },
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

    fmt.prettier,
    fmt.stylua,
    fmt.clang_format,
    fmt.trim_whitespace,

    -- null_act.gitsigns,

    diag.markdownlint,
    fmt.markdownlint,
  },

  -- you can reuse a shared lspconfig on_attach callback here
  on_attach = on_attach,
}

-- Auto-install null-ls sources
local mr = require("mason-registry")
local sources = null_ls.get_sources()
for _, source in ipairs(sources) do
  local ok, p = pcall(mr.get_package, source.name)
  if ok and not p:is_installed() then
    p:install()
  end
end
