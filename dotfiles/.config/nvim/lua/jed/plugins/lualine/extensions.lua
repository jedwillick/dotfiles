local function ft_cap()
  return vim.api.nvim_buf_get_option(0, "filetype"):gsub("^%l", string.upper)
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

  {
    filetypes = { "packer" },
    sections = {
      lualine_a = { ft_cap },
      lualine_c = {
        function()
          return #vim.tbl_keys(packer_plugins) .. " plugins"
        end,
      },
    },
    inactive_sections = {
      lualine_c = {
        ft_cap,
        {
          function()
            return #vim.tbl_keys(packer_plugins) .. " plugins"
          end,
        },
      },
    },
  },
}
