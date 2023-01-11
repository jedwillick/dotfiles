local function reload()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    require("editorconfig").config(buf)
  end
end

return {
  "gpanders/editorconfig.nvim",
  event = "VimEnter",
  config = function()
    vim.api.nvim_create_user_command("EditorConfigConfig", function()
      ---@diagnostic disable-next-line: undefined-field
      vim.pretty_print(vim.b.editorconfig)
    end, { desc = "Show the editorconfig conifg" })

    vim.api.nvim_create_user_command("EditorConfigReload", reload, { desc = "Reload editorconfig" })
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = vim.api.nvim_create_augroup("editorconfig", { clear = false }),
      desc = "Automatically reload editorconfig",
      pattern = ".editorconfig",
      callback = reload,
    })
  end,
}
