local Job = require("plenary.job")

local function capture_version(opts)
  local exe = opts.exe
  local args = opts.args or { "--version" }
  local pattern = opts.pattern or "%d+%.%d+%.%d+"
  local prepend_exe = opts.prepend_exe or false

  if exe == nil then
    error("exe is required")
    return ""
  end

  local out = {}
  Job:new({
    command = exe,
    args = args,
    on_stdout = function(_, line)
      table.insert(out, line)
    end,
  }):sync()

  for _, line in ipairs(out) do
    local version = line:match(pattern)
    if version then
      return prepend_exe and exe .. " " .. version or version
    end
  end
  return ""
end

-- Map filetypes to fetch versions.
local switch = {
  python = { exe = "python3" },
  c = { exe = "gcc", prepend_exe = true },
  make = { exe = "make" },
}

local function get_version()
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local opts = switch[buf_ft]
  if opts then
    return capture_version(opts)
  end
  return ""
end

require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {
      {
        "filename",
        path = 1,
        symbols = {
          modified = " [+]",
          readonly = " [-]",
          unnamed = "[No Name]",
        },
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
        get_version,
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
      },
      {
        function()
          if vim.api.nvim_exec([[echo g:copilot#Enabled()]], true) then
            return [[ﯙ]]
          end
        end,
      },
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { "man", "chadtree" },
}
