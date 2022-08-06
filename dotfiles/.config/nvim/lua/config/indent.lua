vim.opt.list = true
vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("tab:→  ")

require("indent_blankline").setup {
  space_char_blankline = " ",
}

