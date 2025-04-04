vim.opt_local.buflisted = false

local function RemoveQfItems()
  local winid = vim.api.nvim_get_current_win()
  local is_loclist = vim.fn.win_gettype(winid) == 'loclist'
  local what = { items = 0, title = 0 }
  local list = is_loclist and vim.fn.getloclist(0, what) or vim.fn.getqflist(what)

  if #list.items > 0 then
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    if vim.fn.mode() == 'n' then
      table.remove(list.items, row)
    else
      local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
      vim.api.nvim_feedkeys(esc, 'x', false)
      local from = vim.fn.getpos("'<")[2]
      local to = vim.fn.getpos("'>")[2]
      if from > to then
        from, to = to, from
      end

      for pos = to, from, -1 do
        table.remove(list.items, pos)
      end
    end

    if is_loclist then
      vim.fn.setloclist(0, {}, ' ', { items = list.items, title = list.title })
    else
      vim.fn.setqflist({}, ' ', { items = list.items, title = list.title })
    end
    vim.api.nvim_win_set_cursor(0, { math.min(vim.fn.line('$'), row), col })
  end
end

vim.keymap.set('n', 'dd', RemoveQfItems, { buffer = true })
vim.keymap.set('x', 'd', RemoveQfItems, { buffer = true })

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
end, { buffer = true })
