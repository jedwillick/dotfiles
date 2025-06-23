local M = setmetatable({}, {
  __call = function(m, ...)
    return m.format(...)
  end,
})
---
---@param bufnr? number
function M.info(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local gaf = vim.g.autolint == nil or vim.g.autolint
  local baf = vim.b[bufnr].autolint
  local enabled = M.enabled(bufnr)
  local lines = {
    "# Status",
    ("- [%s] global **%s**"):format(gaf and "x" or " ", gaf and "enabled" or "disabled"),
    ("- [%s] buffer **%s**"):format(
      enabled and "x" or " ",
      baf == nil and "inherit" or baf and "enabled" or "disabled"
    ),
  }
  local have = false

  local linters = M.get_linters(true)

  lines[#lines + 1] = "\n# Linters"
  for _, formatter in ipairs(linters) do
    have = true
    lines[#lines + 1] = ("- %s"):format(formatter)
  end

  if not have then
    lines[#lines + 1] = "***No Linters available for this buffer.***"
  end
  vim.notify(
    table.concat(lines, "\n"),
    enabled and vim.log.levels.INFO or vim.log.levels.WARN,
    { title = "Lint (" .. (enabled and "enabled" or "disabled") .. ")" }
  )
end

function M.debounce(ms, fn)
  local timer = vim.uv.new_timer()
  if not timer then
    return
  end

  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end
---@param buf? boolean
---@return string[]
function M.get_linters(buf)
  local lint = require("lint")

  local names = {}
  if buf then
    -- Use nvim-lint's logic first:
    -- * checks if linters exist for the full filetype first
    -- * otherwise will split filetype by "." and add all those linters
    -- * this differs from conform.nvim which only uses the first filetype that has a formatter
    names = lint._resolve_linter_by_ft(vim.bo.filetype)
    -- Add fallback linters.
    if #names == 0 then
      vim.list_extend(names, lint.linters_by_ft["_"] or {})
    end

    -- Add global linters.
    vim.list_extend(names, lint.linters_by_ft["*"] or {})
  else
    for _, namez in pairs(lint.linters_by_ft) do
      vim.list_extend(names, namez or {})
    end
  end

  -- Filter out linters that don't exist or don't match the condition.
  local ctx = { filename = vim.api.nvim_buf_get_name(0) }
  ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
  names = vim.tbl_filter(function(name)
    local linter = lint.linters[name]
    if not linter then
      vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
    end
    return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
  end, names)
  return names
end

function M.lint()
  local names = M.get_linters(true)
  -- Run linters.
  if #names > 0 then
    require("lint").try_lint(names)
  end
end

---@param bufnr? number
function M.enabled(bufnr)
  bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
  local gaf = vim.g.autolint
  local baf = vim.b[bufnr].autolint

  -- If the buffer has a local value, use that
  if baf ~= nil then
    return baf
  end

  -- Otherwise use the global value if set, or true by default
  return gaf == nil or gaf
end

---@param buf? boolean
function M.toggle(buf)
  local names
  if buf then
    vim.b.autolint = not M.enabled()
    names = M.get_linters(true)
  else
    vim.g.autolint = not M.enabled()
    vim.b.autolint = nil
    names = M.get_linters()
  end
  M.info()
  local namespaces = vim.tbl_map(function(name)
    return require("lint").get_namespace(name)
  end, names)

  local diag_toggle = M.enabled() and vim.diagnostic.show or vim.diagnostic.hide

  vim.tbl_map(function(ns)
    diag_toggle(ns, buf and 0 or nil)
  end, namespaces)
end

return M
