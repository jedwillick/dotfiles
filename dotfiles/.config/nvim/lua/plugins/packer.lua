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
  local group = vim.api.nvim_create_augroup("PackerUserConfig", {})
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "plugins.lua", "*/plugins/*.lua" },
    group = group,
    callback = function(args)
      -- Kill all hidden terminals since toggleterm won't
      -- know about them after reload
      local terms = require("toggleterm.terminal").get_all(true)
      for _, term in ipairs(terms) do
        if term.hidden then
          term:shutdown()
        end
      end
      vim.cmd.source(args.file)
      vim.cmd.PackerCompile()
    end,
    desc = "Compile Packer plugins source.",
  })
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
