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
    vim.highlight.on_yank({ higroup = 'Search', timeout = 50 })
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
    -- return to the last edited line
    vim.cmd([[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif]])
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
