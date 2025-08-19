local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  local match = vim.fn.glob(vim.fs.joinpath(workspace, "poetry.lock"))
  if match ~= "" then
    local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
    return vim.fs.joinpath(venv, "bin", "python")
  end

  -- Find and use virtualenv from pipenv in workspace directory.
  match = vim.fn.glob(vim.fs.joinpath(workspace, "Pipfile"))
  if match ~= "" then
    local venv = vim.fn.trim(vim.fn.system("PIPENV_PIPFILE=" .. match .. " pipenv --venv"))
    return vim.fs.joinpath(venv, "bin", "python")
  end

  -- Fallback to system Python.
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

return true
    and {
      {
        "nvim-treesitter",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "python",
          })
        end,
      },
      {
        "mason.nvim",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "pyright",
            "ruff",
          })
        end,
      },
      {
        "nvim-lspconfig",
        opts = {
          servers = {
            ruff = {
              prefer_local = { "uv", "run" },
              keys = {
                {
                  "<leader>co",
                  function()
                    vim.lsp.buf.code_action {
                      apply = true,
                      context = {
                        only = { "source.organizeImports" },
                        diagnostics = {},
                      },
                    }
                  end,
                  desc = "Organize Imports",
                },
              },
            },
            -- pyright = {
            --   before_init = function(_, config)
            --     config.settings.python.pythonPath = get_python_path(config.root_dir)
            --   end,
            -- },
            basedpyright = {}
          },
        },
      },
    }
  or {}
