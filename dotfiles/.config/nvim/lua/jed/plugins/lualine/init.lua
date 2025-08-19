return {
  {
    "jedwillick/version.nvim",
    enabled = false,
    config = true,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function()
      local function in_width()
        return vim.fn.winwidth(0) > 80
      end

      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          -- section_separators = { left = "", right = "" },
          -- component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { "alpha", winbar = { "neo-tree", "toggleterm", "Trouble" } },
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
            -- { "diff", cond = in_width },
            -- { "diagnostics", cond = in_width },
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
                -- local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
                local clients = vim.lsp.get_clients { bufnr = 0 }
                if next(clients) == nil then
                  return msg
                end
                for _, client in ipairs(clients) do
                  return client.name
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
        winbar = {},
        extensions = require("jed.plugins.lualine.extensions"),
      }
    end,
  },
}
