return {
  {
    "famiu/bufdelete.nvim",
    keys = {
      { "<leader>bd", "<cmd>Bdelete<CR>", desc = "Delete buffer" },
      { "<leader>bD", "<cmd>Bdelete!<CR>", desc = "Delete buffer (force)" },
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "BufReadPre",
    keys = {
      { "]b", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "<leader>b]", ":BufferLineMoveNext<CR>", desc = "Move buffer left" },
      { "<leader>b[", ":BufferLineMovePrev<CR>", desc = "Move buffer right" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
      { "<leader>bb", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
      { "<leader>bse", "<cmd>BufferLineSortByExtension<CR>", desc = "Sort buffers (extension)" },
      { "<leader>bsd", "<cmd>BufferLineSortByDirectory<CR>", desc = "Sort buffers (directory)" },
    },
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
    end,
  },
}
