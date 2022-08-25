local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.c_syntax_for_h = 1
g.omni_sql_default_compl_type = "syntax"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 8
opt.number = true
opt.relativenumber = true
opt.wildmenu = true
opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.mouse = ""

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

-- vim.cmd([[
--   augroup RestoreCursorShapeOnExit
--     autocmd!
--     autocmd VimLeave * set guicursor=a:ver25-blinkon100
--   augroup END
-- ]])

vim.cmd([[au BufRead,BufNewFile *.mdx setfiletype markdown]])

vim.keymap.set("n", "<leader>m", function()
  ---@diagnostic disable-next-line: undefined-field
  if opt.mouse._value == "" then
    opt.mouse = "a"
    print("Mouse enabled")
  else
    opt.mouse = ""
    print("Mouse disabled")
  end
end)

vim.keymap.set("n", "<c-s>", ":w<cr>", { silent = true })
