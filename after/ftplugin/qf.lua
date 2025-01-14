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

vim.keymap.set('n', 'dd', function()
  local info = {}

  local line = vim.api.nvim_win_get_cursor(0)[1]
  if #vim.fn.getloclist(0) > 0 then
    info = vim.fn.getloclist(0, { items = true, title = true })
    table.remove(info.items, line)
    vim.fn.setloclist(0, {}, ' ', { items = info.items, title = info.title })
  else
    info = vim.fn.getqflist({ items = true, title = true })
    table.remove(info.items, line)
    vim.fn.setqflist({}, ' ', { items = info.items, title = info.title })
  end
  -- Move the the nth item by number
  vim.cmd(tostring(line))
end, { buffer = 0 })

vim.keymap.set('v', 'd', function()
  local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'x', false)
  local info = {}
  local from = vim.fn.getpos("'<")[2]
  local to = vim.fn.getpos("'>")[2]
  if from > to then
    from, to = to, from
  end
  if #vim.fn.getloclist(0) > 0 then
    info = vim.fn.getloclist(0, { items = true, title = true })
    info.items = table_remove(info.items, from, to)
    vim.fn.setloclist(0, {}, ' ', { items = info.items, title = info.title })
  else
    info = vim.fn.getqflist({ items = true, title = true })
    info.items = table_remove(info.items, from, to)
    vim.fn.setqflist({}, ' ', { items = info.items, title = info.title })
  end
  -- Move the the nth item by number
  vim.cmd(tostring(from))
end, { buffer = 0 })

-- Only can filter by entry's file name and text :)
vim.keymap.set('n', '<c-s>', function()
  if not vim.api.nvim_get_commands({})['Cfilter'] then
    vim.cmd('packadd cfilter')
  end
  local cmd = nil
  if #vim.fn.getloclist(0) > 0 then
    cmd = vim.api.nvim_replace_termcodes(':Lfilter', true, false, true)
  else
    cmd = vim.api.nvim_replace_termcodes(':Cfilter', true, false, true)
  end
  vim.api.nvim_feedkeys(cmd, 'n', true)
end, { buffer = 0 })
