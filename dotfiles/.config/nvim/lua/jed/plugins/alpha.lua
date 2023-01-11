local function version()
  local v = vim.version()
  return v and string.format("v%s.%s.%s", v.major, v.minor, v.patch) or ""
end

return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = string.format(
      [[
 _______                    .__
 \      \   ____  _______  _|__| _____
 /   |   \_/ __ \/  _ \  \/ /  |/     \
/    |    \  ___(  <_> )   /|  |  Y Y  \
\____|__  /\___  >____/ \_/ |__|__|_|  /
        \/     \/                    \/   %s]],
      version()
    )

    dashboard.section.header.val = vim.split(logo, "\n")
    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
      dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
      dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
      dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
      dashboard.button("l", "鈴" .. " Lazy", ":Lazy<CR>"),
      dashboard.button("q", " " .. " Quit", ":qa<CR>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.footer.opts.hl = "Type"
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.opts.layout[1].val = 8
    vim.b.miniindentscope_disable = true

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        once = true,
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        dashboard.section.footer.val =
          string.format("⚡ Lazy loaded %d plugins in %.2f ms", stats.count, stats.startuptime)
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
    vim.keymap.set("n", "<leader>A", function()
      vim.cmd.Alpha()
    end, { desc = "" })
  end,
}
