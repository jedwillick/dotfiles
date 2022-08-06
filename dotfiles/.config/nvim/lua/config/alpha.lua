local alpha = require('alpha')
local startify = require('alpha.themes.startify')

local function version()
  local v = vim.version()
  return "Neovim " .. "v" .. v.major .. '.' .. v.minor .. '.' .. v.patch
end

local sect = startify.section

table.insert(sect.header.val, "")
table.insert(sect.header.val, os.date())

sect.top_buttons.val = {
  startify.button("e", "New File", ":ene <BAR> startinsert <CR>"),
  startify.button("f", "Find File", ":Telescope find_files<CR>")
}

sect.bottom_buttons.val = {
  startify.button("c", "Neovim Config", ":e ~/.config/nvim/init.lua<cr>"),
  startify.button("q", "Quit Neovim", ":qa<CR>"),
}

sect.footer.val = {
  {
    type = 'padding',
    val = 1
  },
  {
    type = 'text',
    val = "Loaded " .. #vim.tbl_keys(packer_plugins) .. " plugins",
    opts = {
      position = "left"
    }
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
