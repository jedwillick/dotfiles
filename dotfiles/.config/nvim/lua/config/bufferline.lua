require("bufferline").setup {
  options = {
    numbers = "buffer_id",
    ---@diagnostic disable-next-line: assign-type-mismatch
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
    offsets = {
      {
        filetype = "CHADTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left",
      },
    },
  },
}

local set = vim.keymap.set
local opts = { silent = true }

-- These commands will navigate through bbuffers in order regardless of which mode you are using
-- e.g. if you change the order of uffers in order regardless of which mode you are using
-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
set("n", "]b", ":BufferLineCycleNext<CR>", opts)
set("n", "[b", ":BufferLineCyclePrev<CR>", opts)

-- These commands will move the current buffer backwards or forwards in the bufferline
set("n", "<leader>bn", ":BufferLineMoveNext<CR>", opts)
set("n", "<leader>bp", ":BufferLineMovePrev<CR>", opts)

-- These commands will sort buffers by language or directory
set("n", "<leader>bse", ":BufferLineSortByExtension<CR>", opts)
set("n", "<leader>bsd", ":BufferLineSortByDirectory<CR>", opts)

-- Delete buffers
set("n", "<leader>bd", ":bdelete<CR>", opts)
set("n", "<leader>bD", ":bdelete!<CR>", opts)
