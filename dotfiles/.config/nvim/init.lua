require("jed.globals")
require("jed.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("jed.plugins", {
  defaults = { lazy = true },
  dev = { path = "~/dev", patterns = { "jedwillick" } },
  install = { missing = true, colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = false },
  change_detection = { enabled = true, notify = false },
  diff = { cmd = "git" },
  ui = { browser = vim.fn.has("wsl") and "explorer.exe" or nil },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
require("jed.commands")
require("jed.keys")
