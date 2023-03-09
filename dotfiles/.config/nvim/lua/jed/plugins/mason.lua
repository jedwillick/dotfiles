return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      -- install_root_dir = os.getenv("HOME") .. "/.local",
      ensure_installed = {
        -- Bash
        { "bash-language-server", version = "4.2.0" }, -- newer versions crash frequently
        "shellcheck",
        "shfmt",
        -- Lua
        "lua-language-server",
        "stylua",
        -- C/C++
        "clangd",
        "clang-format",
        -- Python
        "pyright",
        "black",
        "flake8",
        "isort",
        -- Go
        "golangci-lint",
        "gopls",
        -- Others
        "json-lsp",
        "markdownlint",
        "prettier",
        "vim-language-server",
        "yaml-language-server",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local tool, version
      for _, ensure in ipairs(opts.ensure_installed) do
        if type(ensure) == "table" then
          tool = ensure[1]
          version = ensure.version
        else
          tool = ensure
          version = nil
        end
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install { version = version }
        end
      end
    end,
  },
}
