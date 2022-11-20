M = {}

M.config = {}

local fn = vim.fn

local function bootstrap()
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
    return true
  end
end

local function commands()
  local packer = require("packer")
  local group = vim.api.nvim_create_augroup("PackerUserConfig", {})
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "plugins.lua", "*/plugins/*.lua" },
    group = group,
    callback = function()
      for p, _ in pairs(package.loaded) do
        if p:find("^plugins") or p == "core.plugins" then
          package.loaded[p] = nil
        end
      end
      require("core.plugins")
      packer.compile()
    end,
  })

  vim.api.nvim_create_user_command("Profile", function()
    packer.compile("profile=true")
    packer.profile_output()
    packer.compile()

    if packer_plugins["vim-startuptime"] then
      vim.cmd([[StartupTime]])
    end
  end, { desc = "Run PackerProfile and StartupTime" })
end

function M.setup(spec)
  local bootstrapped = bootstrap()
  commands()

  local packer = require("packer")
  packer.startup { spec, config = M.config }

  if bootstrapped then
    packer.sync()
  elseif fn.empty(fn.glob(packer.config.compile_path)) > 0 then
    packer.compile()
  end
end

return M
