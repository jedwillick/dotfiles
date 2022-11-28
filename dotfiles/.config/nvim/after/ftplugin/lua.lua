vim.keymap.set("n", "<leader>so", function()
  vim.cmd.luafile("%")
  vim.notify("Sourced " .. vim.fn.expand("%:t"))
end)
