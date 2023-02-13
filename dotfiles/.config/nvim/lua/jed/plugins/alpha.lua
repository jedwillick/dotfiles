local function version()
  local v = vim.version()
  return v and string.format("v%s.%s.%s", v.major, v.minor, v.patch) or ""
end

return {
  "goolord/alpha-nvim",
  cmd = "Alpha",
  keys = {
    {
      "<leader>A",
      function()
        vim.cmd.Alpha()
        for _, e in ipairs(require("bufferline").get_elements().elements) do
          vim.schedule(function()
            if e.id == vim.api.nvim_get_current_buf() then
              return
            else
              vim.cmd("bd " .. e.id)
            end
          end)
        end
      end,
      desc = "Alpha",
    },
  },
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
      dashboard.button("n", " " .. " New file", "<cmd>ene <bar> startinsert <cr>"),
      dashboard.button("SPC f f", " " .. " Find file"),
      dashboard.button("SPC f o", " " .. " Old files"),
      dashboard.button("SPC f g", " " .. " Grep files"),
      dashboard.button("SPC f s", " " .. " Sessions"),
      dashboard.button("SPC f p", " " .. " Projects"),
      dashboard.button("SPC L", "鈴" .. " Lazy"),
      dashboard.button("q", " " .. " Quit", "<cmd>qa<cr>"),
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
  end,
}
