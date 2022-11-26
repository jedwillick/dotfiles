local navic = require("nvim-navic")

local function in_width()
  return vim.fn.winwidth(0) > 80
end

require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { winbar = { "neo-tree", "toggleterm" } },
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      { "diff", cond = in_width },
      { "diagnostics", cond = in_width },
    },
    lualine_c = {
      {
        "filename",
        path = 1,
        symbols = {
          modified = " [+]",
          readonly = " [-]",
          unnamed = "[No Name]",
        },
        fmt = function(filename)
          if vim.fn.winwidth(0) > 110 then
            return filename
          end

          return filename:match("^.+/(.+)$") or filename
        end,
      },
    },
    lualine_x = {
      "encoding",
      {
        "fileformat",
        symbols = {
          unix = "LF",
          dos = "CRLF",
          mac = "CR",
        },
      },
      "filetype",
      { -- Version
        function()
          return require("version").get_version().full or ""
        end,
        cond = in_width,
      },
      { -- LSP server name
        function()
          local msg = ""
          local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
          local clients = vim.lsp.get_active_clients()
          if next(clients) == nil then
            return msg
          end
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              return client.name
            end
          end
          return msg
        end,
        cond = in_width,
      },
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "filetype", "progress", "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {
    lualine_c = {
      {
        function()
          if not navic.is_available() then
            return " "
          end
          local bc = navic.get_location { highlight = true }
          if bc == "" then
            return " "
          end
          return bc
        end,
        color = { bg = require("tokyonight.colors").default.bg },
      },
    },
  },
  inactive_winbar = {
    lualine_c = {
      {
        function()
          return " "
        end,
        color = { bg = require("tokyonight.colors").default.bg },
      },
    },
  },
  extensions = require("plugins.lualine.extensions"),
}
