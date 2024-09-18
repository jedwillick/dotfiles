local function lsp_binary_exists(server_config)
  local valid_config = server_config.document_config
    and server_config.document_config.default_config
    and type(server_config.document_config.default_config.cmd) == "table"
    and #server_config.document_config.default_config.cmd >= 1

  if not valid_config then
    return false
  end

  local binary = server_config.document_config.default_config.cmd[1]

  return vim.fn.executable(binary) == 1
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      {
        "folke/neodev.nvim",
        opts = {
          override = function(root_dir, library)
            local dots = os.getenv("DOTFILES")
            if root_dir == dots or root_dir == dots .. "/dotfiles/.config/nvim" then
              library.enable = true
              library.plugins = true
            end
          end,
        },
      },
      "hrsh7th/cmp-nvim-lsp",
      "mason.nvim",
    },
    opts = {},
    config = function(_, opts)
      local default_on_codelens = vim.lsp.codelens.on_codelens
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.codelens.on_codelens = function(err, lenses, ctx, _)
        if err or not lenses or not next(lenses) then
          return default_on_codelens(err, lenses, ctx, _)
        end
        for _, lens in pairs(lenses) do
          if lens and lens.command and lens.command.title then
            lens.command.title = "     " .. lens.command.title
          end
        end
        return default_on_codelens(err, lenses, ctx, _)
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      local lspconfig = require("lspconfig")

      require("jed.util.lsp").on_attach(function(client, buf)
        -- client.server_capabilities.semanticTokensProvider = nil
        require("jed.plugins.lsp.keys").on_attach(client, buf)
      end)

      for lsp, lsp_opts in pairs(opts.servers) do
        if not (lspconfig[lsp] and lspconfig[lsp].setup) then
          goto continue
        end

        if lsp_opts.prefer_local then
          local default_conf = require("lspconfig.server_configurations." .. lsp)
          lsp_opts.cmd = vim.list_extend(lsp_opts.prefer_local, lsp_opts.cmd or default_conf.default_config.cmd)
        end

        --[[ and lsp_binary_exists(lspconfig[lsp])  ]]

        lsp_opts.capabilities = vim.tbl_deep_extend("force", capabilities, lsp_opts.capabilities or {})
        if lsp == "hls" then
          lsp_opts.keys = nil
          vim.g.haskell_tools = lsp_opts
        else
          lspconfig[lsp].setup(lsp_opts)
        end
        ::continue::
      end
    end,
  },
}
