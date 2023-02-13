return {
  -- Mainly just using it for nice docs and notify
  "folke/noice.nvim",
  cmd = "Noice",
  event = "VeryLazy",
  keys = {
    { "<leader>nl", "<cmd>Noice last<cr>", desc = "Noice Last Message" },
    { "<leader>nh", "<cmd>Noice history<cr>", desc = "Noice History" },
    { "<leader>nt", "<cmd>Noice telescope<cr>", desc = "Noice Telescope" },

    {
      "<c-f>",
      function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end,
      silent = true,
      expr = true,
      desc = "Scroll forward",
    },
    {
      "<c-b>",
      function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end,
      silent = true,
      expr = true,
      desc = "Scroll backward",
    },
  },
  opts = {
    presets = {
      long_message_to_split = true,
      inc_rename = true,
    },
    -- cmdline = { view = "cmdline" },
    cmdline = { enabled = false },
    messages = { enabled = false },
    popupmenu = { enabled = false },
    lsp = {
      progress = { enabled = false },
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    views = {
      mini = {
        position = { row = -2 },
        win_options = { winblend = 100 },
      },
    },
    commands = {
      history = { view = "popup" },
      last = { view = "popup" },
      errors = { view = "popup" },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          find = "%d+L, %d+B",
        },
        view = "mini",
      },
      {
        view = "notify",
        filter = { event = "msg_showmode" },
      },
    },
  },
}
