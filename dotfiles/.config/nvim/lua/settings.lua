local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.c_syntax_for_h = 1
g.omni_sql_default_compl_type = "syntax"
g.omni_sql_no_default_maps = 1

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 4
opt.number = true
opt.relativenumber = true
opt.wildmenu = true
opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.mouse = ""
opt.signcolumn = "yes"

vim.filetype.add {
  extension = {
    mdx = "markdown",
    sql = "plsql",
  },
  filename = {
    [".clang-format"] = "yaml",
  },
}

local toggleEvent = function(arg)
  for _, v in pairs(vim.opt.eventignore:get()) do
    if v == arg.args then
      vim.opt.eventignore:remove(arg.args)
      vim.notify(arg.args .. " enabled")
      return
    end
  end
  vim.opt.eventignore:append(arg.args)
  vim.notify(arg.args .. " disabled")
end

vim.api.nvim_create_user_command("ToggleOnSave", function()
  toggleEvent { args = "BufWritePre" }
end, {})
vim.api.nvim_create_user_command("ToggleEvent", toggleEvent, { nargs = 1, complete = "event" })

vim.keymap.set("n", "<leader>m", function()
  if vim.opt.mouse:get().a then
    opt.mouse = ""
    vim.notify("Mouse disabled")
  else
    opt.mouse = "a"
    vim.notify("Mouse enabled")
  end
end)

vim.keymap.set({ "n", "i" }, "<c-s>", "<esc>:w<cr>", { silent = true })
