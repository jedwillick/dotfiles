vim.g.mapleader = " "

vim.g.c_syntax_for_h = 1
vim.g.omni_sql_default_compl_type = "syntax" -- Only use syntax for SQL complete
vim.g.omni_sql_no_default_maps = 1 -- Don't set mappings

vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Default 2 spaces as indent
vim.opt.tabstop = 4 -- When using tabs

vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "winpos" }
vim.opt.number = true -- Print line number
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.autowrite = true -- auto write changes
vim.opt.termguicolors = true -- True color support
vim.opt.clipboard = "unnamedplus" -- sync with system clipboard
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.mouse = "a" -- enable mouse mode
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.list = true -- Show some invisible characters
vim.opt.showmode = false -- Don't show  mode since it is in statusline
vim.opt.undofile = true --  Save undo history to disk

vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sidescrolloff = 8 -- Columns of context

