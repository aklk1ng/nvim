local au = vim.api.nvim_create_autocmd
local aklk1ng = vim.api.nvim_create_augroup('aklk1ngGroup', {})

au('FileType', {
  group = aklk1ng,
  pattern = { 'help', 'checkhealth', 'dashboard', 'qf', 'netrw' },
  callback = function(arg)
    vim.keymap.set('n', 'q', _G._cmd('quit'), { buffer = arg.buf, silent = true, nowait = true })
  end,
  desc = 'Quit some buffers quickly',
})

au('TextYankPost', {
  group = aklk1ng,
  callback = function()
    vim.hl.on_yank()
  end,
  desc = 'Highlight text when yank',
})

au('BufReadPost', {
  group = aklk1ng,
  callback = function()
    local pos = vim.fn.getpos('\'"')
    if pos[2] > 0 and pos[2] <= vim.fn.line('$') then
      vim.api.nvim_win_set_cursor(0, { pos[2], pos[3] - 1 })
      vim.api.nvim_input('zz')
    end
  end,
  desc = 'Return to the last edited position',
})

au({ 'BufRead', 'BufNewFile' }, {
  once = true,
  group = aklk1ng,
  callback = function()
    require('core.lsp')
    require('utils')
  end,
  desc = 'Lazy load lsp config and some plugins',
})

if vim.fn.executable('fcitx5-remote') == 1 then
  au('InsertLeavePre', {
    group = aklk1ng,
    callback = function()
      os.execute('fcitx5-remote -c')
    end,
    desc = 'Automatically switch fcitx5 input method',
  })
end
