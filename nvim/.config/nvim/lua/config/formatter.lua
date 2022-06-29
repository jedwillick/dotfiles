local ft = require("formatter.filetypes")
local util = require "formatter.util"

require("formatter").setup {
  logging = true,
  log_level = vim.log.levels.WARN,
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
    sh = {
      function()
        return {
          exe = "shfmt",
          args = {
            "-i",
            "2",
            "-ci",
            "-bn",
            "--filename",
            util.escape_path(util.get_current_buffer_file_path()),
          },
          stdin = true,
        }
      end
    },
    ["*"] = {
      ft.any.remove_trailing_whitespace
    }
  }
}

vim.cmd([[
augroup FormatAutogroup
autocmd!
autocmd BufWritePost * Format
augroup END
]])

local opts = { noremap = true, silent = true }
nmap("<leader>f", ":Format<CR>", opts)
nmap("<leader>F", ":FormatWrite<CR>", opts)
