local aklk1ng = vim.api.nvim_create_augroup('aklk1ngGroup', {})
local api = vim.api

api.nvim_create_autocmd('FileType', {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    vim.cmd('syntax off')
  end,
})

api.nvim_create_autocmd('FileType', {
  group = aklk1ng,
  pattern = { 'help', 'man', 'checkhealth', 'dashboard' },
  callback = function(arg)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = arg.buf, silent = true, nowait = true })
  end,
})

api.nvim_create_autocmd('TextYankPost', {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 100 })
  end,
})

api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    -- Formatter
    local current_dir = vim.fn.expand('%:p:h')
    if current_dir:find('neovim', 1, true) or current_dir:find('dwm', 1, true) then
      vim.w.format = false
    else
      vim.w.format = true
    end
  end,
})

api.nvim_create_autocmd('BufWritePost', {
  group = aklk1ng,
  pattern = {
    '*.c',
    '*.cpp',
    '*.cmake',
    '*.python',
    '*.go',
    '*.rs',
    '*.lua',
    '*.markdown',
    '*.sh',
    '*.zig',
    '*.html',
    '*.css',
    '*.json',
    '*.javascript',
    '*.typescript',
    '*.toml',
  },
  callback = function()
    if vim.w.format then
      vim.cmd('GuardFmt')
    else
      vim.cmd([[%s/\s\+$//e]])
    end
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

api.nvim_create_autocmd('BufReadPost', {
  group = aklk1ng,
  pattern = '*',
  callback = function()
    -- auto place to last edit
    vim.cmd([[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif]])
  end,
})
