vim.keymap.set({ "n", "t" }, "<A-m>", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt.mouse:get().a then
    vim.opt.mouse = ""
    vim.notify("Mouse disabled")
  else
    vim.opt.mouse = "a"
    vim.notify("Mouse enabled")
  end
end, { desc = "Toggle Mouse" })

vim.keymap.set({ "n", "i" }, "<c-s>", "<cmd>w<cr><esc>")
vim.keymap.set({ "n", "i" }, "<esc>", "<cmd>noh<cr><esc>", { silent = true })
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>")
