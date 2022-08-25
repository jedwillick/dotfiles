-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/jed/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/jed/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/jed/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/jed/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/jed/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { 'require("Comment").setup()' },
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["alpha-nvim"] = {
    config = { "require('config/alpha')" },
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["bufferline.nvim"] = {
    config = { 'require("config/bufferline")' },
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  chadtree = {
    commands = { "CHADopen" },
    config = { "\27LJ\2\2Å\1\0\0\4\0\a\0\n5\0\1\0005\1\0\0=\1\2\0006\1\3\0009\1\4\0019\1\5\1'\2\6\0\18\3\0\0B\1\3\1K\0\1\0\22chadtree_settings\17nvim_set_var\bapi\bvim\20keymap.tertiary\1\0\0\1\3\0\0\n<c-t>\18<middlemouse>\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/jed/.local/share/nvim/site/pack/packer/opt/chadtree",
    url = "https://github.com/ms-jpq/chadtree"
  },
  ["copilot.vim"] = {
    config = { "\27LJ\2\2ﬂ\1\0\0\5\0\v\0\0176\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\3\0009\0\4\0'\1\5\0'\2\6\0'\3\a\0005\4\b\0B\0\5\0016\0\0\0009\0\1\0005\1\n\0=\1\t\0K\0\1\0\1\0\1\20TelescopePrompt\1\22copilot_filetypes\1\0\4\texpr\2\vscript\2\21replace_keycodes\1\vsilent\2\27copilot#Accept(\"<CR>\")\n<C-j>\6i\bset\vkeymap\23copilot_no_tab_map\6g\bvim\0" },
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["coq.artifacts"] = {
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/coq.artifacts",
    url = "https://github.com/ms-jpq/coq.artifacts"
  },
  ["coq.thirdparty"] = {
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/coq.thirdparty",
    url = "https://github.com/ms-jpq/coq.thirdparty"
  },
  coq_nvim = {
    after = { "mason.nvim" },
    config = { "\27LJ\2\2–\1\0\0\3\0\b\0\0146\0\0\0009\0\1\0005\1\3\0=\1\2\0006\0\4\0'\1\5\0B\0\2\0024\1\3\0005\2\6\0>\2\1\0015\2\a\0>\2\2\1B\0\2\1K\0\1\0\1\0\3\bsrc\fnvimlua\15short_name\tnLUA\14conf_only\1\1\0\3\bsrc\fcopilot\15short_name\bCOP\15accept_key\n<c-j>\vcoq_3p\frequire\1\0\1\15auto_start\fshut-up\17coq_settings\6g\bvim\0" },
    loaded = true,
    only_config = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/coq_nvim",
    url = "https://github.com/ms-jpq/coq_nvim"
  },
  ["impatient.nvim"] = {
    config = { "require('impatient')" },
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\2í\1\0\0\3\0\t\0\0176\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0009\0\3\0\18\1\0\0009\0\4\0'\2\5\0B\0\3\0016\0\6\0'\1\a\0B\0\2\0029\0\b\0B\0\1\1K\0\1\0\nsetup\21indent_blankline\frequire\14space:‚ãÖ\vappend\14listchars\tlist\bopt\bvim\0" },
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["lualine.nvim"] = {
    config = { "require('config/lualine')" },
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/jed/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    config = { "require('config/lsp')" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/jed/.local/share/nvim/site/pack/packer/opt/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-colorizer.lua"] = {
    commands = { "ColorizerToggle" },
    config = { 'require("colorizer").setup(colorizerFileTypes)' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/jed/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { "require('config/treesitter')" },
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-endwise"] = {
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/nvim-treesitter-endwise",
    url = "https://github.com/RRethy/nvim-treesitter-endwise"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["sideways.vim"] = {
    commands = { "SidewaysLeft", "SidewaysRight" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/jed/.local/share/nvim/site/pack/packer/opt/sideways.vim",
    url = "https://github.com/AndrewRadev/sideways.vim"
  },
  ["telescope-file-browser.nvim"] = {
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-project.nvim"] = {
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/telescope-project.nvim",
    url = "https://github.com/nvim-telescope/telescope-project.nvim"
  },
  ["telescope-ui-select.nvim"] = {
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/telescope-ui-select.nvim",
    url = "https://github.com/nvim-telescope/telescope-ui-select.nvim"
  },
  ["telescope.nvim"] = {
    config = { "require('config/telescope')" },
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    config = { "\27LJ\2\2ˇ\1\0\0\2\0\n\0\0216\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0+\1\1\0=\1\4\0006\0\0\0009\0\1\0+\1\1\0=\1\5\0006\0\0\0009\0\1\0005\1\a\0=\1\6\0006\0\0\0009\0\b\0'\1\t\0B\0\2\1K\0\1\0\27colorscheme tokyonight\bcmd\1\5\0\0\aqf\15vista_kind\rterminal\vpacker\24tokyonight_sidebars\31tokyonight_italic_comments\31tokyonight_italic_keywords\nstorm\21tokyonight_style\6g\bvim\0" },
    loaded = true,
    path = "/home/jed/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  undotree = {
    commands = { "UndotreeToggle" },
    config = { "vim.g.undotree_SetFocusWhenToggle = 1" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/jed/.local/share/nvim/site/pack/packer/opt/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-startuptime"] = {
    commands = { "StartupTime" },
    config = { "vim.g.startuptime_tries = 10" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/jed/.local/share/nvim/site/pack/packer/opt/vim-startuptime",
    url = "https://github.com/dstein64/vim-startuptime"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: sideways.vim
time([[Setup for sideways.vim]], true)
try_loadstring("\27LJ\2\2ç\1\0\0\4\0\b\0\0156\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\4\0'\3\5\0B\0\4\0016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\6\0'\3\a\0B\0\4\1K\0\1\0\23:SidewaysRight<CR>\14<leader>l\22:SidewaysLeft<CR>\14<leader>h\6n\bset\vkeymap\bvim\0", "setup", "sideways.vim")
time([[Setup for sideways.vim]], false)
-- Setup for: chadtree
time([[Setup for chadtree]], true)
vim.keymap.set("n", "<leader>t", ":CHADopen<cr>")
time([[Setup for chadtree]], false)
-- Setup for: undotree
time([[Setup for undotree]], true)
vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")
time([[Setup for undotree]], false)
-- Setup for: nvim-colorizer.lua
time([[Setup for nvim-colorizer.lua]], true)
vim.keymap.set("n", "<leader>ct", "<cmd>ColorizerToggle<cr>")
time([[Setup for nvim-colorizer.lua]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
require('config/telescope')
time([[Config for telescope.nvim]], false)
-- Config for: coq_nvim
time([[Config for coq_nvim]], true)
try_loadstring("\27LJ\2\2–\1\0\0\3\0\b\0\0146\0\0\0009\0\1\0005\1\3\0=\1\2\0006\0\4\0'\1\5\0B\0\2\0024\1\3\0005\2\6\0>\2\1\0015\2\a\0>\2\2\1B\0\2\1K\0\1\0\1\0\3\bsrc\fnvimlua\15short_name\tnLUA\14conf_only\1\1\0\3\bsrc\fcopilot\15short_name\bCOP\15accept_key\n<c-j>\vcoq_3p\frequire\1\0\1\15auto_start\fshut-up\17coq_settings\6g\bvim\0", "config", "coq_nvim")
time([[Config for coq_nvim]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\2í\1\0\0\3\0\t\0\0176\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0009\0\3\0\18\1\0\0009\0\4\0'\2\5\0B\0\3\0016\0\6\0'\1\a\0B\0\2\0029\0\b\0B\0\1\1K\0\1\0\nsetup\21indent_blankline\frequire\14space:‚ãÖ\vappend\14listchars\tlist\bopt\bvim\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: impatient.nvim
time([[Config for impatient.nvim]], true)
require('impatient')
time([[Config for impatient.nvim]], false)
-- Config for: copilot.vim
time([[Config for copilot.vim]], true)
try_loadstring("\27LJ\2\2ﬂ\1\0\0\5\0\v\0\0176\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\3\0009\0\4\0'\1\5\0'\2\6\0'\3\a\0005\4\b\0B\0\5\0016\0\0\0009\0\1\0005\1\n\0=\1\t\0K\0\1\0\1\0\1\20TelescopePrompt\1\22copilot_filetypes\1\0\4\texpr\2\vscript\2\21replace_keycodes\1\vsilent\2\27copilot#Accept(\"<CR>\")\n<C-j>\6i\bset\vkeymap\23copilot_no_tab_map\6g\bvim\0", "config", "copilot.vim")
time([[Config for copilot.vim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
require('config/lualine')
time([[Config for lualine.nvim]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
require('config/alpha')
time([[Config for alpha-nvim]], false)
-- Config for: bufferline.nvim
time([[Config for bufferline.nvim]], true)
require("config/bufferline")
time([[Config for bufferline.nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
require("Comment").setup()
time([[Config for Comment.nvim]], false)
-- Config for: tokyonight.nvim
time([[Config for tokyonight.nvim]], true)
try_loadstring("\27LJ\2\2ˇ\1\0\0\2\0\n\0\0216\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0+\1\1\0=\1\4\0006\0\0\0009\0\1\0+\1\1\0=\1\5\0006\0\0\0009\0\1\0005\1\a\0=\1\6\0006\0\0\0009\0\b\0'\1\t\0B\0\2\1K\0\1\0\27colorscheme tokyonight\bcmd\1\5\0\0\aqf\15vista_kind\rterminal\vpacker\24tokyonight_sidebars\31tokyonight_italic_comments\31tokyonight_italic_keywords\nstorm\21tokyonight_style\6g\bvim\0", "config", "tokyonight.nvim")
time([[Config for tokyonight.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
require('config/treesitter')
time([[Config for nvim-treesitter]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd null-ls.nvim ]]
vim.cmd [[ packadd mason.nvim ]]

-- Config for: mason.nvim
require('config/lsp')

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SidewaysRight lua require("packer.load")({'sideways.vim'}, { cmd = "SidewaysRight", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'vim-startuptime'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SidewaysLeft lua require("packer.load")({'sideways.vim'}, { cmd = "SidewaysLeft", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ColorizerToggle lua require("packer.load")({'nvim-colorizer.lua'}, { cmd = "ColorizerToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file UndotreeToggle lua require("packer.load")({'undotree'}, { cmd = "UndotreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CHADopen lua require("packer.load")({'chadtree'}, { cmd = "CHADopen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType html ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "html" }, _G.packer_plugins)]]
vim.cmd [[au FileType css ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "css" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType toml ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "toml" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascript ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "javascript" }, _G.packer_plugins)]]
vim.cmd [[au FileType yaml ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "yaml" }, _G.packer_plugins)]]
vim.cmd [[au FileType json ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "json" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
