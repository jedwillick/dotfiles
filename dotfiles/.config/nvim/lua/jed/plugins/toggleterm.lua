return {
  "akinsho/toggleterm.nvim",
  event = "User VeryLazy",
  config = function()
    local terminal = require("toggleterm.terminal")

    local function get_next_terminal(term)
      local terms = terminal.get_all()
      for i, v in ipairs(terms) do
        if v == term then
          return terms[i + 1] or terms[1]
        end
      end
    end

    local function get_prev_terminal(term)
      local terms = terminal.get_all()
      for i = #terms, 1, -1 do
        if terms[i] == term then
          return terms[i - 1] or terms[#terms]
        end
      end
    end

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

    local Terminal = terminal.Terminal

    local float = Terminal:new {
      cmd = "bash",
      direction = "float",
      hidden = true,
    }

    local btop = Terminal:new {
      cmd = "btop",
      direction = "float",
      hidden = true,
      on_open = function(term)
        pcall(vim.keymap.del, "t", "<esc>", { buffer = term.bufnr })
      end,
    }

    local spt = Terminal:new {
      cmd = "spt",
      direction = "float",
      hidden = true,
      on_open = function(term)
        pcall(vim.keymap.del, "t", "<esc>", { buffer = term.bufnr })
      end,
    }

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

      local t = Terminal:new {
        cmd = cmd,
        direction = "float",
        hidden = true,
      }
      repls[ft] = t
      return t
    end

    vim.keymap.set("n", "<leader>tf", function()
      float:toggle()
    end, { desc = "toggleterm float" })

    vim.keymap.set("n", "<leader>ts", function()
      spt:toggle()
    end, { desc = "toggleterm float" })

    vim.keymap.set("n", "<leader>tb", function()
      btop:toggle()
    end, { desc = "toggleterm btop" })

    vim.keymap.set("n", "<leader>tr", function()
      local t = repl()
      if t then
        t:toggle()
      end
    end, { desc = "toggleterm repl" })
  end,
}
