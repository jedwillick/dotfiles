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

function M.spec()
  return {}
end

---@return (LazyKeys|{has?:string})[]
function M.resolve(bufnr)
  local Keys = require("lazy.core.handler.keys")
  if not Keys.resolve then
    return {}
  end
  local spec = M.spec()
  local opts = require("jed.util.lsp").opts("nvim-lspconfig")
  local clients = vim.lsp.get_clients { bufnr = bufnr }
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(client, bufnr)
  M.opts = { noremap = true, silent = true, buffer = bufnr }
  M.map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Telescope Diagnostics" })
  M.map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Goto Definition" })
  M.map("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "Goto References" })
  M.map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Goto Implementation" })
  M.map("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Goto Type Definition" })
  M.map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
  M.map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  M.map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  M.map({ "i", "n" }, "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

  M.map("n", "<leader>cr", M.rename, { desc = "Rename", expr = true })
  M.map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

  if client.supports_method("textDocument/codeLens") then
    M.map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Run Code Lens" })
    M.map("n", "<leader>cL", vim.lsp.codelens.refresh, { desc = "Refresh Code Lens" })
  end

  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(bufnr)

  for _, keys in pairs(keymaps) do
    if not keys.has then
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = bufnr
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return M
