local aklk1ng = vim.api.nvim_create_augroup('aklk1ngGroup', {})
local api = vim.api

api.nvim_create_autocmd('FileType', {
  group = aklk1ng,
  pattern = { 'help', 'checkhealth', 'dashboard', 'qf', 'netrw' },
  callback = function(arg)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = arg.buf, silent = true, nowait = true })
  end,
})

api.nvim_create_autocmd('TextYankPost', {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'Search', timeout = 75 })
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
      vim.api.nvim_win_set_cursor(0, { pos[2], pos[3] - 1 })
    end
  end,
})

api.nvim_create_autocmd('TermOpen', {
  group = aklk1ng,
  callback = function()
    vim.opt_local.stc = ''
    vim.wo.number = false
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
