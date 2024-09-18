local M = setmetatable({}, {
  __call = function(m, ...)
    return m.format(...)
  end,
})

---@param bufnr? number
function M.info(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local gaf = vim.g.autoformat == nil or vim.g.autoformat
  local baf = vim.b[bufnr].autoformat
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

  local formatters = vim.tbl_map(function(f)
    return f.name
  end, require("conform").list_formatters())

  vim.list_extend(formatters, require("jed.util.lsp").get_format_clients())

  lines[#lines + 1] = "\n# Formatters"
  for _, formatter in ipairs(formatters) do
    have = true
    lines[#lines + 1] = ("- %s"):format(formatter)
  end

  if not have then
    lines[#lines + 1] = "\n***No formatters available for this buffer.***"
  end
  vim.notify(
    table.concat(lines, "\n"),
    enabled and vim.log.levels.INFO or vim.log.levels.WARN,
    { title = "Format (" .. (enabled and "enabled" or "disabled") .. ")" }
  )
end

---@param bufnr? number
function M.enabled(bufnr)
  bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
  local gaf = vim.g.autoformat
  local baf = vim.b[bufnr].autoformat

  -- If the buffer has a local value, use that
  if baf ~= nil then
    return baf
  end

  -- Otherwise use the global value if set, or true by default
  return gaf == nil or gaf
end

---@param buf? boolean
function M.toggle(buf)
  if buf then
    vim.b.autoformat = not M.enabled()
  else
    vim.g.autoformat = not M.enabled()
    vim.b.autoformat = nil
  end
  M.info()
end

function M.format(opts)
  local conform = require("conform")

  -- get current formatter names
  local formatters, isLsp = conform.list_formatters_to_run()
  local fmt_names = {}

  if not vim.tbl_isempty(formatters) then
    fmt_names = vim.tbl_map(function(f)
      return f.name
    end, formatters)
  end

  if isLsp then
    fmt_names = vim.list_extend(fmt_names, require("jed.util.lsp").get_format_clients())
  end

  if vim.tbl_isempty(fmt_names) then
    vim.notify("No formatters configured!", vim.log.WARN)
  end

  local msg_handle = require("fidget.progress").handle.create {
    title = "formatting",
    lsp_client = { name = table.concat(fmt_names, "/") }, -- the fake lsp client name
    percentage = 0, -- skip percentage field
  }

  -- format with auto close popup, and notify if err
  conform.format(opts, function(err)
    msg_handle:finish()
    -- if err then
    --   vim.notify(err, vim.log.levels.WARN, { title = "Formatting" })
    -- end
  end)
end

return M
