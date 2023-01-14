M = {}

M.autoformat = true
M.augroup = vim.api.nvim_create_augroup("LspFormatting", {})

function M.toggle()
  M.autoformat = not M.autoformat
  vim.notify(
    string.format("%s format on save", M.autoformat and "Enabled" or "Disabled"),
    vim.log.levels.INFO,
    { title = "Format" }
  )
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
  local nls_format = #require("null-ls.sources").get_available(ft, require("null-ls").methods.FORMATTING) > 0
  vim.lsp.buf.format {
    filter = function(client)
      if nls_format then
        return client.name == "null-ls"
      else
        return not (client.name == "null-ls")
      end
    end,
    bufnr = buf,
  }
end

function M.on_attach(client, buf)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds { group = M.augroup, buffer = buf }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = M.augroup,
      buffer = buf,
      callback = function()
        if M.autoformat then
          M.format()
        end
      end,
    })
  end
end
return M
