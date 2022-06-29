require("bufferline").setup {
  options = {
    numbers = "buffer_id",
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
    offsets = {
      {
        filetype = "CHADTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left"
      }
    }
  }
}

local opts = { noremap = true, silent = true }

-- These commands will navigate through bbuffers in order regardless of which mode you are using
-- e.g. if you change the order of uffers in order regardless of which mode you are using
-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
nmap("[b", ":BufferLineCycleNext<CR>", opts)
nmap("]b", ":BufferLineCyclePrev<CR>", opts)

-- These commands will move the current buffer backwards or forwards in the bufferline
nmap("<leader>bn", ":BufferLineMoveNext<CR>", opts)
nmap("<leader>bp", ":BufferLineMovePrev<CR>", opts)

-- These commands will sort buffers by language or directory
nmap("<leader>bse", ":BufferLineSortByExtension<CR>", opts)
nmap("<leader>bsd", ":BufferLineSortByDirectory<CR>", opts)

-- Delete buffers
nmap("<leader>bd", ":bdelete<CR>", opts)
