local M = {}

function M.map(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", M.opts, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.rename()
  if pcall(require, "inc_rename") then
    return ":IncRename " .. vim.fn.expand("<cword>")
  else
    vim.lsp.buf.rename()
  end
end

function M.on_attach(client, buf)
  M.opts = { noremap = true, silent = true, buffer = buf }
  M.map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Telescope Diagnostics" })
  M.map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Goto Definition" })
  M.map("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "Goto References" })
  M.map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Goto Implementation" })
  M.map("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Goto Type Definition" })
  M.map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
  M.map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  M.map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  M.map({ "i", "n" }, "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  M.map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
  M.map("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

  M.map("n", "<leader>cr", M.rename, { desc = "Rename", expr = true })
  M.map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

  if client.supports_method("textDocument/formatting") then
    local fmt = require("jed.plugins.lsp.formatting")
    M.map({ "n", "v" }, "<leader>cf", fmt.format, { desc = "Format" })
    M.map("n", "<leader>cF", fmt.toggle, { desc = "Toggle format on save" })
  end
  if client.supports_method("textDocument/codeLens") then
    M.map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Run Code Lens" })
  end
  if client.name == "haskell-tools.nvim" then
    M.map("n", "<leader>ch", function()
      require("haskell-tools").hoogle.hoogle_signature()
    end, { desc = "Search Hoogle (Signature)" })
    M.map("n", "<leader>cH", function()
      require("haskell-tools").hoogle.hoogle_signature { search_term = vim.fn.expand("<cword>") }
    end, { desc = "Search Hoogle (Current word)" })
  end
end
return M
