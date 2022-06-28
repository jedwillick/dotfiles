local alpha = require('alpha')
local startify = require('alpha.themes.startify')

local function version()
  local version = vim.version()
  local print_version = "v" .. version.major .. '.' .. version.minor .. '.' .. version.patch
  local datetime = os.date('%Y/%m/%d %H:%M:%S')

  return "Neovim " .. "v" .. version.major .. '.' .. version.minor .. '.' .. version.patch
end

local s = startify.section

s.bottom_buttons.val = {
  startify.button("c", "Neovim Config", ":e ~/.config/nvim/init.lua<cr>"),
}

s.footer.val = {
  {
    type = 'padding', 
    val = 1 
  },
  { 
    type = 'text', 
    val = version(),
    opts = {
      position = 'left'
    }
  },
}

alpha.setup(startify.config)

nmap("<c-n>", ":Alpha<cr>", { noremap = true })
