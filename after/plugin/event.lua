local au = vim.api.nvim_create_autocmd

au('FileType', {
  group = _G._augroup,
  pattern = { 'help', 'checkhealth', 'dashboard', 'qf', 'netrw' },
  callback = function(args)
    vim.keymap.set('n', 'q', _G._cmd('quit'), { buffer = args.buf, silent = true, nowait = true })
  end,
})

-- https://github.com/nvim-treesitter/nvim-treesitter/issues/6436
-- Fuck treesitter
au('FileType', {
  group = _G._augroup,
  pattern = { 'python' },
  callback = function(args)
    if not pcall(vim.treesitter.get_parser, args.buf, args.match) then
      return
    end
    vim.o.syntax = 'on'
  end,
})

au('TextYankPost', {
  group = _G._augroup,
  callback = function()
    vim.hl.on_yank()
  end,
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
})

au({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = _G._augroup,
  callback = function()
    vim.cmd('checktime')
  end,
})

au({ 'BufRead', 'BufNewFile' }, {
  once = true,
  group = _G._augroup,
  callback = function()
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
})

if vim.fn.executable('fcitx5-remote') == 1 then
  au('InsertLeavePre', {
    group = _G._augroup,
    callback = function()
      os.execute('fcitx5-remote -c')
    end,
  })
end
