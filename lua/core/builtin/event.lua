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
    vim.highlight.on_yank()
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

au('TermOpen', {
  group = aklk1ng,
  callback = function()
    vim.o.number = false
    vim.o.signcolumn = 'no'
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

au('FileType', {
  group = aklk1ng,
  callback = function(args)
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end
    -- Disable foldexpr in bigfile.
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > 500 * 1024 then
      return
    end

    api.nvim_buf_call(args.buf, function()
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
      vim.cmd.normal('zx')
    end)
  end,
})

au('BufEnter', {
  group = aklk1ng,
  callback = function()
    local bufname = api.nvim_buf_get_name(0)
    if not vim.uv.fs_stat(bufname) then
      return
    end

    local cwd = vim.fs.dirname(bufname)
    -- Try to get root from lsp.
    vim.tbl_map(function(client)
      local filetypes, root = client.config.filetypes, client.config.root_dir
      if filetypes and vim.fn.index(filetypes, vim.bo.ft) ~= -1 and root then
        vim.cmd.lcd(root)
        return
      end
    end, vim.lsp.get_clients({ buf = 0 }))
    -- Try to find a file that's supposed to be in the root.
    local result = vim.fs.find(_G.root_patterns, { path = cwd, upward = true, stop = vim.env.HOME })
    if not vim.tbl_isempty(result) then
      vim.cmd.lcd(vim.fs.dirname(result[1]))
      return
    end
    vim.cmd.lcd(cwd)
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
