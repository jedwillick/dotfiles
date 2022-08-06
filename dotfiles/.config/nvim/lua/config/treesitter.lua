require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',
  highlight = {
    enable = true
  },
  indent = {
    enable = true,
    disable = { 'python' }
  },
  endwise = { enable = true },
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99
