M = {}

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.name == "copilot" then
        return -- Copilot doesn't need any extras
      end
      on_attach(client, buffer)
    end,
  })
end

function M.get_format_clients()
  local clients = vim.lsp.get_clients()
  local fmt_clients = {}

  for _, client in ipairs(clients) do
    if client.supports_method("textDocument/formatting") then
      table.insert(fmt_clients, client.name)
    end
  end
  return fmt_clients
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

return M
