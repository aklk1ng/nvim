local au = vim.api.nvim_create_autocmd
local aklk1ng = vim.api.nvim_create_augroup('aklk1ngGroup', {})

au('FileType', {
  group = aklk1ng,
  pattern = { 'help', 'checkhealth', 'dashboard', 'qf', 'netrw', 'scratch' },
  callback = function(arg)
    vim.keymap.set('n', 'q', _G.cmd('quit'), { buffer = arg.buf, silent = true, nowait = true })
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
      vim.api.nvim_win_set_cursor(0, { pos[2], pos[3] - 1 })
      vim.api.nvim_input('zz')
    end
  end,
})

au({ 'BufRead', 'BufNewFile' }, {
  once = true,
  group = aklk1ng,
  callback = function()
    require('core.lsp')
    require('utils')
  end,
})

-- https://github.com/neovim/neovim/commit/b192d58284a791c55f5ae000250fc948e9098d47
au('FileType', {
  callback = function(args)
    if args.match == 'asl' then
      return
    end
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end

    vim.api.nvim_buf_call(args.buf, function()
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
      vim.cmd.normal('zx')
    end)
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
