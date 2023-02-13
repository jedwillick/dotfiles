local cursor

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  desc = "Restore cursor on exit/suspend",
  callback = function()
    cursor = vim.opt.guicursor:get()
    vim.opt.guicursor = "a:ver1-blinkon100"
  end,
})

vim.api.nvim_create_autocmd("VimResume", {
  desc = "Restore cursor on resume",
  callback = function()
    vim.opt.guicursor = cursor
  end,
})

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

vim.api.nvim_create_user_command("ToggleFormatSave", function()
  require("jed.plugins.lsp.formatting").toggle()
end, { desc = "Toggle format on save" })

vim.api.nvim_create_user_command(
  "ToggleEvent",
  toggleEvent,
  { nargs = 1, complete = "event", desc = "Toggle an event" }
)

vim.api.nvim_create_user_command("Shebang", function()
  local bangs = {
    sh = { "sh", "bash" },
    bash = "bash",
    fish = "fish",
    python = "python3",
  }
  local has_shebang = function()
    return vim.api.nvim_buf_get_text(0, 0, 0, 0, 2, {})[1] == "#!"
  end
  local callback = function(bang)
    if has_shebang() then
      vim.notify("Shebang already exists")
      return
    end

    vim.api.nvim_buf_set_lines(0, 0, 0, false, { "#!/usr/bin/env " .. bang })
    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        if has_shebang() then
          vim.cmd([[silent !chmod u+x %]])
        end
      end,
      buffer = 0,
      once = true,
    })
  end

  local ft = vim.bo.filetype
  if not bangs[ft] or type(bangs[ft]) == "table" then
    vim.ui.select(not bangs[ft] and vim.tbl_values(bangs) or bangs[ft], {
      prompt = "Select shebang",
    }, function(choice)
      if not choice then
        return
      end
      callback(choice)
      vim.cmd([[filetype detect]])
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
    vim.bo.shiftwidth = 4
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

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function()
    vim.diagnostic.reset()
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 1 then
      local file = vim.fn.fnamemodify(vim.fn.argv(0), ":p")
      local stat = vim.loop.fs_stat(file)
      if stat and stat.type == "directory" then
        vim.cmd.chdir(file)
        vim.cmd.Alpha()
        require("telescope.builtin").find_files {
          cwd = file,
        }
      end
    end
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

vim.keymap.set({ "n", "i" }, "<c-s>", "<cmd>w<cr><esc>")
vim.keymap.set({ "n", "i" }, "<esc>", "<cmd>noh<cr><esc>", { silent = true })
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>")
