pcall(require, "impatient")

require("core.globals")
require("core.plugins")
require("core.settings")
vim.defer_fn(function()
  -- vim.api.nvim_exec_autocmds("User PackerDefered", {})
  vim.cmd.doautocmd("User PackerDefered")
end, 100)
