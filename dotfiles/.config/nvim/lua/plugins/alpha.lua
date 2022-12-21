local alpha = require("alpha")
local startify = require("alpha.themes.startify")

local function version()
  local v = vim.version()
  return v and string.format("Neovim v%s.%s.%s", v.major, v.minor, v.patch) or ""
end

local function loaded()
  return "Loaded "
    .. #vim.tbl_keys(packer_plugins)
    .. " plugins, "
    .. #require("lspconfig.util").available_servers() + #require("null-ls").get_sources()
    .. " LSP sources, "
    .. #require("nvim-treesitter.parsers").available_parsers()
    .. " TS parsers"
end

local sect = startify.section

table.insert(sect.header.val, "")
table.insert(sect.header.val, os.date())

sect.top_buttons.val = {
  startify.button("e", "New File", ":ene <BAR> startinsert <CR>"),
  startify.button("f", "Find File", ":Telescope find_files<CR>"),
}

sect.bottom_buttons.val = {
  startify.button("c", "Neovim Config", ":e ~/.config/nvim/init.lua<cr>"),
  startify.button("q", "Quit Neovim", ":qa<CR>"),
}

sect.footer.val = {
  {
    type = "padding",
    val = 1,
  },
  {
    type = "text",
    val = loaded(),
  },
  {
    type = "text",
    val = version(),
  },
}

alpha.setup(startify.config)

vim.keymap.set("n", "<c-n>", function()
  vim.cmd.only()
  vim.cmd.bufdo("bd")
  vim.bo.buflisted = false
  vim.cmd.Alpha()
end, { desc = "Clean buffers/windows" })
