local function new_float(opts)
  opts = vim.tbl_deep_extend("force", {
    direction = "float",
    hidden = true,
    on_open = function(term)
      pcall(vim.keymap.del, "t", "<esc>", { buffer = term.bufnr })
    end,
  }, opts or {})
  return require("toggleterm.terminal").Terminal:new(opts)
end

local function get_next_terminal(term)
  local terms = require("toggleterm.terminal").get_all()
  for i, v in ipairs(terms) do
    if v == term then
      return terms[i + 1] or terms[1]
    end
  end
end

local function get_prev_terminal(term)
  local terms = require("toggleterm.terminal").get_all()
  for i = #terms, 1, -1 do
    if terms[i] == term then
      return terms[i - 1] or terms[#terms]
    end
  end
end

local cmds = {
  python = "python3",
  lua = "luajit",
  haskell = "ghci",
  javascript = "node",
}

local rlwrap = {
  lua = "-pBlue",
}

local repls = {}

local function repl()
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  if repls[ft] then
    return repls[ft]
  end

  local cmd = cmds[ft]

  if not cmd or vim.fn.executable(cmd) ~= 1 then
    vim.notify("No repl for filetype " .. ft, vim.log.levels.WARN, { title = "DOTFILES: toggleterm" })
    return nil
  end

  if vim.fn.executable("rlwrap") == 1 and rlwrap[ft] then
    cmd = string.format("rlwrap %s %s", rlwrap[ft], cmd)
  end

  repls[ft] = new_float { cmd = cmd, on_open = nil }
  return repls[ft]
end

return {
  "akinsho/toggleterm.nvim",
  cmd = "ToggleTerm",
  keys = { [[<c-\>]], "<leader>t" },
  config = function()
    require("toggleterm").setup {
      open_mapping = [[<c-\>]],
      terminal_mappings = true,
      float_opts = {
        winblend = 0,
        border = "curved",
      },
      highlights = {
        NormalFloat = { guibg = "#191c29" },
        FloatBorder = { guibg = "#191c29", guifg = "DarkGrey" },
      },
      winbar = {
        enabled = true,
      },
      on_open = function(term)
        local opts = { buffer = term.bufnr }
        vim.keymap.set("t", "<esc>", [[<c-\><c-n>]], opts)
        vim.keymap.set("n", "<esc>", "<cmd>q<cr>", opts)
        if not term.hidden then
          vim.keymap.set("n", "]t", function()
            term:close()
            get_next_terminal(term):open()
            vim.cmd.stopinsert()
          end, opts)
          vim.keymap.set("n", "[t", function()
            term:close()
            get_prev_terminal(term):open()
            vim.cmd.stopinsert()
          end, opts)
        end
      end,
    }

    local float = new_float { on_open = nil }
    vim.keymap.set("n", "<leader>tf", function()
      float:toggle()
    end, { desc = "Float" })

    local spt = new_float { cmd = "spt" }
    vim.keymap.set("n", "<leader>ts", function()
      spt:toggle()
    end, { desc = "Spotify-tui" })

    local btop = new_float { cmd = "btop" }
    vim.keymap.set("n", "<leader>tb", function()
      btop:toggle()
    end, { desc = "btop" })

    vim.keymap.set("n", "<leader>tr", function()
      local t = repl()
      if t then
        t:toggle()
      end
    end, { desc = "repl" })
  end,
}
