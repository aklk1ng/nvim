local api = vim.api
local aklk1ng = api.nvim_create_augroup('aklk1ngGroup', {})

api.nvim_create_autocmd('FileType', {
  group = aklk1ng,
  pattern = { 'help', 'checkhealth', 'dashboard', 'qf', 'netrw', 'query' },
  callback = function(arg)
    _G.map('n', 'q', _G.cmd('quit'), { buffer = arg.buf, silent = true, nowait = true })
  end,
})

api.nvim_create_autocmd('FileType', {
  group = aklk1ng,
  pattern = 'qf',
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

api.nvim_create_autocmd('TextYankPost', {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'Search', timeout = 80 })
  end,
})

api.nvim_create_autocmd('BufWritePre', {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    -- remove trailing spaces
    vim.cmd([[silent %s/\s\+$//e]])
  end,
})

api.nvim_create_autocmd('BufReadPost', {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    -- return to the last edited position
    local pos = vim.fn.getpos('\'"')
    if pos[2] > 0 and pos[2] <= vim.fn.line('$') then
      api.nvim_win_set_cursor(0, { pos[2], pos[3] - 1 })
      api.nvim_input('zz')
    end
  end,
})

-- Check if we need to reload the file when it changed
api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = aklk1ng,
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

api.nvim_create_autocmd('TermOpen', {
  group = aklk1ng,
  callback = function()
    vim.o.number = false
    vim.o.signcolumn = 'no'
  end,
})

-- just load lazily when not opening a file
api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  once = true,
  group = aklk1ng,
  pattern = '*',
  callback = function()
    require('core.builtin.stl').setup()
    require('core.builtin.lsp')
    require('utils')
  end,
})

api.nvim_create_autocmd('BufEnter', {
  once = true,
  group = aklk1ng,
  pattern = '*',
  callback = function()
    require('keymap')
  end,
})

if vim.fn.executable('fcitx5-remote') == 1 then
  api.nvim_create_autocmd('InsertLeavePre', {
    group = aklk1ng,
    pattern = '*',
    callback = function()
      os.execute('fcitx5-remote -c')
    end,
  })
end
