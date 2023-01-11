return {
  "akinsho/bufferline.nvim",
  event = "BufReadPre",
  config = function()
    require("bufferline").setup {
      options = {
        numbers = "none",
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "TelescopeNormal",
            text_align = "center",
          },
        },
      },
    }

    local set = vim.keymap.set
    local opts = { silent = true }

    -- These commands will navigate through bbuffers in order regardless of which mode you are using
    -- e.g. if you change the order of uffers in order regardless of which mode you are using
    -- e.g. if you change the order of buffers <cmd>bnext and <cmd>bprevious will not respect the custom ordering
    set("n", "]b", "<cmd>BufferLineCycleNext<CR>", opts)
    set("n", "[b", "<cmd>BufferLineCyclePrev<CR>", opts)

    -- These commands will move the current buffer backwards or forwards in the bufferline
    set("n", "<leader>bn", ":BufferLineMoveNext<CR>", opts)
    set("n", "<leader>bp", ":BufferLineMovePrev<CR>", opts)

    -- Toggle the pin on current buffer
    set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", opts)

    -- Select a buffer
    set("n", "<leader>bb", "<cmd>BufferLinePick<cr>", opts)

    -- These commands will sort buffers by language or directory
    set("n", "<leader>bse", "<cmd>BufferLineSortByExtension<CR>", opts)
    set("n", "<leader>bsd", "<cmd>BufferLineSortByDirectory<CR>", opts)

    -- Delete buffers
    set("n", "<leader>bd", "<cmd>Bdelete<CR>", opts)
    set("n", "<leader>bD", "<cmd>Bdelete!<CR>", opts)
  end,
}
