require("bufferline").setup {
  options = {
    numbers = "buffer_id",
    diagnostics = "nvim_lsp",
  }
}

local opts = {noremap = true, silent = true}

-- These commands will navigate through buffers in order regardless of which mode you are using
-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
nmap("[b", ":BufferLineCycleNext<CR>", opts)
nmap("]b", ":BufferLineCyclePrev<CR>", opts)

-- These commands will move the current buffer backwards or forwards in the bufferline
nmap("nb", ":BufferLineMoveNext<CR>", opts)
nmap("pb", ":BufferLineMovePrev<CR>", opts)

-- These commands will sort buffers by language or directory
nmap("be", ":BufferLineSortByExtension<CR>", opts)
nmap("bd", ":BufferLineSortByDirectory<CR>", opts)

