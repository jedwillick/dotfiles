local function capture_version(cmds)
  for _, cmd in ipairs(cmds) do
    local f = io.popen(cmd, 'r')
    if f ~= nil then
      local s = f:read('*l')
      if s ~= nil then
        f:close()
        return s
      end
    end
  end
  return ''
end

local function get_version()
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local str = ''
  if buf_ft == "python" then
    str = capture_version({"python3 --version", "python --version"})
    str = vim.trim(vim.split(str, " ")[2])
  elseif buf_ft == "make" then
    str = capture_version({"make --version"})
  elseif buf_ft == "c" or buf_ft == "cpp" then
    str = capture_version({"gcc --version"})
    str = string.gsub(str, "%b() ", "")
  end
  return str
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = {
          modified = " [+]",
          readonly = " [-]",
          unnamed = "[No Name]"
        }
      }
    },
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype',
      { -- Version
        get_version
      },
      { -- LSP server name
        function()
          local msg = ''
          local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
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
      }
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {"man"}
}
