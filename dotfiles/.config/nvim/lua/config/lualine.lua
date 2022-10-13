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
  return opts and capture_version(opts) or ""
end

local function ft_upper()
  return vim.api.nvim_buf_get_option(0, "filetype"):upper()
end

local help_man = {
  filetypes = { "help", "man" },
  sections = {
    lualine_a = { ft_upper },
    lualine_b = { { "filename", file_status = false } },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_c = {
      ft_upper,
      { "filename", file_status = false },
    },
    lualine_x = { "progress", "location" },
  },
}

local function in_width()
  return vim.fn.winwidth(0) > 80
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
        get_version,
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
      {
        function()
          if vim.api.nvim_exec([[echo g:copilot#Enabled()]], true) then
            return [[ﯙ]]
          end
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
    lualine_x = { "progress", "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { help_man, "chadtree" },
}
