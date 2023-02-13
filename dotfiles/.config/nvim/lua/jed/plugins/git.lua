return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = true,
  },
  {
    "tpope/vim-fugitive",
    event = "User VeryLazy",
  },
}
