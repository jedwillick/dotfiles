vim.g.mapleader = " "
vim.g.c_syntax_for_h = 1
vim.g.omni_sql_default_compl_type = "syntax"
vim.g.omni_sql_no_default_maps = 1

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wildmenu = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.mouse = ""
vim.opt.signcolumn = "yes"
vim.opt.list = true

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

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "help",
    "man",
    "startuptime",
    "lspinfo",
    "tsplayground",
  },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { silent = true, buffer = 0 })
    vim.bo.buflisted = false
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.fn.mkdir(vim.fn.expand("<afile>:p:h"), "p")
  end,
})

vim.api.nvim_create_user_command("Profile", function()
  vim.cmd.PackerCompile("profile=true")
  vim.defer_fn(vim.cmd.PackerProfile, 1000)
  if packer_plugins["vim-startuptime"] then
    vim.cmd.StartupTime()
  end
end, { desc = "Run PackerProfile and StartupTime" })

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function()
    vim.diagnostic.reset()
  end,
})

vim.keymap.set({ "n", "t" }, "<A-m>", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt.mouse:get().a then
    vim.opt.mouse = ""
    vim.notify("Mouse disabled")
  else
    vim.opt.mouse = "a"
    vim.notify("Mouse enabled")
  end
end)

vim.keymap.set({ "n", "i" }, "<c-s>", "<esc><cmd>w<cr>", { silent = true })
vim.keymap.set("n", "<leader>nh", "<cmd>noh<cr>", { silent = true })
