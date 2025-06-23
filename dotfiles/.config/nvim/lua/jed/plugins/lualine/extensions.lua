local function ft_cap()
  return vim.api.nvim_get_option_value("filetype", { buf = 0 }):gsub("^%l", string.upper)
end

local tspg = function()
  return "TSPlayground"
end

return {
  "neo-tree",
  {
    filetypes = { "startuptime", "alpha" },
    sections = {
      lualine_a = { ft_cap },
    },
    inactive_sections = {
      lualine_c = { ft_cap },
    },
  },
  {
    filetypes = { "help", "man" },
    sections = {
      lualine_a = { ft_cap },
      lualine_c = { { "filename", file_status = false } },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_c = {
        ft_cap,
        { "filename", file_status = false },
      },
      lualine_x = { "progress", "location" },
    },
  },

  {
    filetypes = { "tsplayground" },
    sections = {
      lualine_a = { tspg },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_c = { tspg },
      lualine_x = { "progress", "location" },
    },
  },
}
