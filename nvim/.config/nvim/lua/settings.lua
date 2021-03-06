local o = vim.opt
local g = vim.g

g.mapleader = [[ ]]

o.expandtab = true
o.shiftwidth = 2
o.tabstop = 8
o.number = true
o.wildmenu = true
o.termguicolors = true
o.clipboard = 'unnamedplus'

-- Only needed if xclip is installed
-- g.clipboard = {
--   name = "win32yank-wsl",
--   copy = {
--     ["+"] = "win32yank.exe -i --crlf",
--     ["*"] = "win32yank.exe -i --crlf"
--   },
--   paste = {
--     ["+"] = "win32yank.exe -o --lf",
--     ["*"] = "win32yank.exe -o --lf"
--   },
--   cache_enable = 0,
-- }


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
