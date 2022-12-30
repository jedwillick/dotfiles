vim.keymap.set("n", "<leader>so", function()
  vim.cmd.write("%")
  vim.cmd.luafile("%")
  vim.notify("Sourced " .. vim.fn.expand("%:t"), vim.log.levels.INFO, { title = "DOTFILES" })
end)
