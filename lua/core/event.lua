local au = vim.api.nvim_create_autocmd

au('FileType', {
  group = _G._augroup,
  pattern = { 'help', 'checkhealth', 'dashboard', 'qf', 'netrw' },
  callback = function(arg)
    vim.keymap.set('n', 'q', _G._cmd('quit'), { buffer = arg.buf, silent = true, nowait = true })
  end,
  desc = 'Quit some buffers quickly',
})

au('TextYankPost', {
  group = _G._augroup,
  callback = function()
    vim.hl.on_yank()
  end,
  desc = 'Highlight text when yank',
})

au('BufReadPost', {
  group = _G._augroup,
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
  group = _G._augroup,
  callback = function()
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    require('core.lsp')
    require('utils')
  end,
  desc = 'Lazy load for startuptime',
})

if vim.fn.executable('fcitx5-remote') == 1 then
  au('InsertLeavePre', {
    group = _G._augroup,
    callback = function()
      os.execute('fcitx5-remote -c')
    end,
    desc = 'Automatically switch fcitx5 input method',
  })
end
