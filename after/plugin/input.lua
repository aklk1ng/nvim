---@diagnostic disable-next-line: duplicate-set-field
vim.ui.input = function(opts, on_confirm)
  local mode = vim.fn.mode()
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'cursor',
    width = math.max(40, vim.api.nvim_strwidth(opts.prompt or '')),
    anchor = 'SW',
    row = 0,
    col = 0,
    height = 1,
    style = 'minimal',
    border = 'single',
    title = opts.prompt or 'Input',
  })

  vim.wo[win].wrap = false
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].winhl = 'Normal:Normal'
  vim.bo[buf].filetype = 'Scratch'

  if opts.default then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { opts.default })
  end

  vim.keymap.set('n', '<C-c>', function()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
    on_confirm(nil)
  end, { buffer = buf })
  vim.keymap.set('n', '<CR>', function()
    local text = vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1]
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
    if mode == 'n' then
      vim.api.nvim_input('<Esc>l')
    end
    on_confirm(text)
  end, { buffer = buf })
end
