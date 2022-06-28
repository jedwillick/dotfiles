local ft = require("formatter.filetypes")

require("formatter").setup {
  logging = true,
  filetype = {
    c = {
      ft.c.clangformat
    },
    python = {
      ft.python.black
    },
    go = {
      ft.go.gofmt
    },
    ["*"] = {
      ft.any.remove_trailing_whitespace
    }
  }
}

vim.cmd([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]])

local opts = { noremap = true, silent = true }
nmap("<leader>f", ":Format<CR>", opts)
nmap("<leader>F", ":FormatWrite<CR>", opts)
