vim.g.mapleader = " "

vim.g.c_syntax_for_h = 1
vim.g.omni_sql_default_compl_type = "syntax" -- Only use syntax for SQL complete
vim.g.omni_sql_no_default_maps = 1 -- Don't set mappings

vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Default 2 spaces as indent
vim.opt.tabstop = 4 -- When using tabs

vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "winpos" }
vim.opt.number = true -- Print line number
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.autowrite = true -- auto write changes
vim.opt.termguicolors = true -- True color support
vim.opt.clipboard = "unnamedplus" -- sync with system clipboard
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.mouse = "a" -- enable mouse mode
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.list = true -- Show some invisible characters
vim.opt.showmode = false -- Don't show  mode since it is in statusline
vim.opt.undofile = true --  Save undo history to disk

vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sidescrolloff = 8 -- Columns of context

local toggleEvent = function(arg)
  for _, v in pairs(vim.opt.eventignore:get()) do
    if v == arg.args then
      vim.opt.eventignore:remove(arg.args)
      vim.notify(arg.args .. " enabled")
      return
    end
  end
  vim.opt.eventignore:append(arg.args)
  vim.notify(arg.args .. " disabled")
end

vim.api.nvim_create_user_command("ToggleOnSave", function()
  toggleEvent { args = "BufWritePre" }
end, {})
vim.api.nvim_create_user_command("ToggleEvent", toggleEvent, { nargs = 1, complete = "event" })

vim.api.nvim_create_user_command("Shebang", function()
  local bangs = {
    sh = "#!/usr/bin/env bash",
    python = "#!/usr/bin/env python3",
  }
  local callback = function(bang)
    local text = vim.api.nvim_buf_get_text(0, 0, 0, 0, 2, {})[1]
    if text == "#!" then
      vim.notify("Shebang already exists")
      return
    end

    vim.api.nvim_buf_set_lines(0, 0, 0, false, { bang })
    vim.api.nvim_create_autocmd("BufWritePost", {
      command = "silent !chmod u+x %",
      buffer = 0,
      once = true,
    })
  end

  local ft = vim.bo.filetype
  if ft == "" then
    vim.ui.select(vim.tbl_values(bangs), {
      prompt = "Select shebang",
    }, function(choice)
      if not choice then
        return
      end
      callback(choice)
      local lookup = vim.tbl_add_reverse_lookup(bangs)
      vim.bo.filetype = lookup[choice]
    end)
  elseif bangs[ft] then
    callback(bangs[ft])
  else
    vim.notify("No shebang for " .. ft)
    return
  end
end, { desc = "Add shebang to file and make it executable" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "python",
    "c",
    "cpp",
    "ps1",
  },
  callback = function()
    vim.bo.shiftwidth = 4
  end,
  desc = "Set shiftwidth to 4",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "go",
    "make",
  },
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 4
  end,
  desc = "Use tabs",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "help",
    "man",
    "startuptime",
    "lspinfo",
    "tsplayground",
  },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { silent = true, buffer = 0 })
    vim.bo.buflisted = false
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.fn.mkdir(vim.fn.expand("<afile>:p:h"), "p")
  end,
})

vim.api.nvim_create_user_command("Profile", function()
  vim.cmd.PackerCompile("profile=true")
  vim.defer_fn(vim.cmd.PackerProfile, 1000)
  if packer_plugins["vim-startuptime"] then
    vim.cmd.StartupTime()
  end
end, { desc = "Run PackerProfile and StartupTime" })

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function()
    vim.diagnostic.reset()
  end,
})

vim.keymap.set({ "n", "t" }, "<A-m>", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt.mouse:get().a then
    vim.opt.mouse = ""
    vim.notify("Mouse disabled")
  else
    vim.opt.mouse = "a"
    vim.notify("Mouse enabled")
  end
end, { desc = "Toggle Mouse" })

vim.keymap.set({ "n", "i" }, "<c-s>", "<esc><cmd>w<cr>", { silent = true })
vim.keymap.set({ "n", "i" }, "<esc>", "<cmd>noh<cr><esc>", { silent = true })
vim.keymap.set("n", "<leader>pi", "<cmd>PackerInstall<cr>")
vim.keymap.set("n", "<leader>ps", "<cmd>PackerSync<cr>")
