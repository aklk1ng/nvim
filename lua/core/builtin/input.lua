local api, set = vim.api, vim.api.nvim_set_option_value

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.input = function(opts, on_confirm)
  local mode = vim.fn.mode()
  -- Setup window according to spec.
  local buf = api.nvim_create_buf(true, false)
  local win = api.nvim_open_win(buf, true, {
    relative = 'cursor',
    width = math.max(40, api.nvim_strwidth(opts.prompt or '')),
    anchor = 'SW',
    row = 0,
    col = 0,
    height = 1,
    style = 'minimal',
    border = 'single',
    title = opts.prompt or 'Input',
  })
  set('wrap', false, { win = win })
  set('number', false, { win = win })
  set('relativenumber', false, { win = win })
  set('winhl', 'Normal:Terminal', { win = win })
  set('filetype', 'input', { buf = buf })
  set('tabstop', 1, { buf = buf })
  -- Prepare for input.
  if opts.default then
    api.nvim_buf_set_lines(buf, 0, -1, false, { opts.default })
  end
  _G.map('n', '<Esc>', function()
    api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
    api.nvim_input('<Esc>l')
    on_confirm(nil)
  end, { buffer = buf })
  _G.map({ 'i', 'n' }, '<cr>', function()
    local text = api.nvim_buf_get_lines(buf, 0, -1, false)[1]
    api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
    if mode == 'n' then
      api.nvim_input('<Esc>l')
    end
    on_confirm(text)
  end, { buffer = buf })
end
