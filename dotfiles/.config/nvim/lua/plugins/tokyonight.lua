require("tokyonight").setup {
  style = "storm",
  styles = {
    comments = { italic = false },
    keywords = { italic = false },
  },
  sidebars = { "qf", "vista_kind", "terminal", "packer", "neo-tree" },
  on_highlights = function(hl, c)
    -- current line number
    hl.CursorLineNr = {
      fg = c.orange,
      bold = true,
    }

    -- borderless telescope
    local prompt = "#2d3149"
    hl.TelescopeNormal = {
      bg = c.bg_dark,
    }
    hl.TelescopeBorder = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
    hl.TelescopePromptNormal = {
      bg = prompt,
    }
    hl.TelescopePromptBorder = {
      bg = prompt,
      fg = prompt,
    }
    hl.TelescopePromptTitle = {
      bg = c.fg_gutter,
      fg = c.orange,
    }
    hl.TelescopePreviewTitle = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
    hl.TelescopeResultsTitle = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
    hl.CmpItemKindCopilot = {
      fg = "#6CC644",
    }
  end,
}

vim.cmd([[colorscheme tokyonight]])
vim.cmd([[colorscheme tokyonight]])
