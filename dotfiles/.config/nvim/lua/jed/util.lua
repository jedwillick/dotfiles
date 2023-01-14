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
return M
