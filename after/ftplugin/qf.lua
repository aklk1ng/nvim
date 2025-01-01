vim.opt_local.buflisted = false

-- https://wsdjeg.net/key-bindings-for-neovim-quickfix-window/

---Remove elements from index `from` to `to`, and return a new table.
---@param t vim.quickfix.entry[] Return value with `getqflist()`.
---@param from integer Left index.
---@param to integer Right index.
---@return vim.quickfix.entry[]
local function table_remove(t, from, to)
  local rst = {}
  for i = 1, #t, 1 do
    if i < from or i > to then
      rst[#rst + 1] = t[i]
    end
  end
  return rst
end

_G.map('n', 'dd', function()
  local qflist = vim.fn.getqflist()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  table.remove(qflist, line)
  vim.fn.setqflist(qflist)
  -- Move the the nth item by number
  vim.cmd(tostring(line))
end, { buffer = 0 })

_G.map('v', 'd', function()
  local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'x', false)
  local qflist = vim.fn.getqflist()
  local from = vim.fn.getpos("'<")[2]
  local to = vim.fn.getpos("'>")[2]
  if from > to then
    from, to = to, from
  end
  qflist = table_remove(qflist, from, to)
  vim.fn.setqflist(qflist)
  -- Move the the nth item by number
  vim.cmd(tostring(from))
end, { buffer = 0 })
