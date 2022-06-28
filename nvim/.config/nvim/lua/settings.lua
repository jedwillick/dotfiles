local opt = vim.opt
local g = vim.g

g.mapleader = [[ ]]

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 8
opt.number = true
opt.wildmenu = true
opt.termguicolors = true

g.tokyonight_style = "storm"
g.tokyonight_italic_keywords = false
g.tokyonight_italic_comments = false
g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
vim.cmd('colorscheme tokyonight')

vim.cmd([[
  augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver25-blinkon100
  augroup END
]])
