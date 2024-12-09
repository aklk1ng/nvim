local api, au = vim.api, vim.api.nvim_create_autocmd
local aklk1ng = api.nvim_create_augroup('aklk1ngGroup', {})

au('FileType', {
  group = aklk1ng,
  pattern = { 'help', 'checkhealth', 'dashboard', 'qf', 'netrw', 'query' },
  callback = function(arg)
    _G.map('n', 'q', _G.cmd('quit'), { buffer = arg.buf, silent = true, nowait = true })
  end,
})

au('TextYankPost', {
  group = aklk1ng,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Return to the last edited position.
au('BufReadPost', {
  group = aklk1ng,
  callback = function()
    local pos = vim.fn.getpos('\'"')
    if pos[2] > 0 and pos[2] <= vim.fn.line('$') then
      api.nvim_win_set_cursor(0, { pos[2], pos[3] - 1 })
      api.nvim_input('zz')
    end
  end,
})

-- Check if we need to reload the file when it changed.
au({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = aklk1ng,
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

au('FileType', {
  group = aklk1ng,
  callback = function(args)
    if args.match == 'asl' then
      return
    end
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end

    api.nvim_buf_call(args.buf, function()
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
      vim.cmd.normal('zx')
    end)
  end,
})

au({ 'BufRead', 'BufNewFile' }, {
  once = true,
  group = aklk1ng,
  callback = function()
    require('core.builtin.lsp')
    require('utils')
  end,
})

au('BufEnter', {
  once = true,
  group = aklk1ng,
  callback = function()
    require('keymap')
  end,
})

if vim.fn.executable('fcitx5-remote') == 1 then
  au('InsertLeavePre', {
    group = aklk1ng,
    callback = function()
      os.execute('fcitx5-remote -c')
    end,
  })
end
